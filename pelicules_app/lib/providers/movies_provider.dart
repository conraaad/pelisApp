//Provider de les pelicules, aqui farem els request http

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:pelicules_app/models/models.dart';

//Aquest sera el nostre provider, pq sigui un provider ha de heredar de ChangeNotifier que serveix per compartir info

class MoviesProvider extends ChangeNotifier{

  final String _apiKey = '1a474fe8ab2a382b7c5579057212b3ab';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es-ES';
  int _pNumPopular = 0;
  int _pNumTopRated = 0;

  Map<int, String> genres = {};

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  List<Movie> topRatedMovies = [];

  //Actors pero identificats per id de pelicula (evitar peticions si els tenim en mem)
  Map<int, List<Cast>> moviesCast = {};
  //Crew pero identificats per id de pelicula (evitar peticions si els tenim en mem)
  Map<int, List<Cast>> moviesCrew = {};

  //Cast Detail pero identificats pel seu id
  Map<int, CastDetail> actorsById = {};

  MoviesProvider(){
    getGenres();
    getNowPlayingMovies();
    getPopularMovies();
    getTopRatedMovies();
  }

  //Fa una peticio dels tots els generes amb els seus corresponents IDs, ho guarda a genres
  void getGenres() async {
    final url = Uri.https(_baseUrl, '3/genre/movie/list', {
      'api_key' : _apiKey,
      'language' : _language,
    });

    final response = await http.get(url);
    final genresList = GenresResponse.fromRawJson(response.body);
    genres = genresList.genres;
    notifyListeners();
  }

  //Fa una peticio al endpoint determinat => retorna un String json com a future
  Future<String> _getJson(String endpoint, [int page = 1]) async {
    //Parametres entre claudators son opcionals
    final url = Uri.https(_baseUrl, endpoint, {
      'api_key' : _apiKey,
      'language' : _language,
      'page' : '$page',
    });

    final response = await http.get(url);
    return response.body;
  }

  //peticio de pelicules en cinemes => guarda llista a onDisplayMovies
  void getNowPlayingMovies() async {
    
    //important la importacio, serveix per convertir l'objecte json en un mapa
    //final Map<String, dynamic> data = json.decode(response.body);         //aixo ja ho fem al nostre model
    //print(nowPlaying.results[0].title);

    final jsonData = await _getJson('3/movie/now_playing');
    final nowPlaying = NowPlayingResponse.fromRawJson(jsonData);
    onDisplayMovies = nowPlaying.results;

    //aixo serveix per avisar a tots els widgets que depenen d'aquesta data que es redibuixin
    notifyListeners();
  }

  //peticio de pelicules populars => guarda llista a popularMovies
  void getPopularMovies() async {
    _pNumPopular++;
    final jsonData = await _getJson('3/movie/popular', _pNumPopular);
    final popular = PopularResponse.fromRawJson(jsonData);
    List<Movie> tmp = popular.results;
    tmp.sort((a, b) => b.voteCount.compareTo(a.voteCount));

    //aqui copiem 
    popularMovies = [...popularMovies, ...tmp];
    notifyListeners();
  }

  //peticio de pelicules millor valorades => guarda llista a topRatedMovies
  void getTopRatedMovies() async {
    _pNumTopRated++;
    final jsonData = await _getJson('3/movie/top_rated', _pNumTopRated);
    final topRated = PopularResponse.fromRawJson(jsonData);
    List<Movie> tmp = topRated.results;
    tmp.sort((a, b) => b.voteCount.compareTo(a.voteCount));
    
    //aqui copiem 
    topRatedMovies = [...topRatedMovies, ...tmp];
    notifyListeners();
  }
  
  //peticio d'actors d'una pelicula amb id: id => retorna llista de cast com a future
  Future<List<Cast>> getMovieCast(int id) async {

    //manetenim la pelicula en memoria pq no vagi fent la mateixa peticio http una vegada rere l'altre
    if (moviesCast.containsKey(id)) return moviesCast[id]!;

    //print('Demanant info actors!');
    final jsonData = await _getJson('3/movie/$id/credits');
    final castResponse = CastResponse.fromRawJson(jsonData);

    moviesCast[id] = castResponse.cast;
    moviesCrew[id] = castResponse.crew;
    return castResponse.cast;
  }

  //peticio de crew d'una pelicula amb id: id => retorna llista de cast com a future
  Future<List<Cast>> getMovieCrew(int id) async {

    //manetenim la pelicula en memoria pq no vagi fent la mateixa peticio http una vegada rere l'altre
    if (moviesCrew.containsKey(id)) return moviesCrew[id]!;

    //print('Demanant info actors!');
    final jsonData = await _getJson('3/movie/$id/credits');
    final crewResponse = CastResponse.fromRawJson(jsonData);

    moviesCast[id] = crewResponse.cast;
    moviesCrew[id] = crewResponse.crew;
    return crewResponse.crew;
  }

  //peticio de cerca de pelicules a la lupa => retorna una llista de pelicules com a future
  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(_baseUrl, '3/search/movie', {
      'api_key' : _apiKey,
      'language' : _language,
      'query' : query,
    });

    final response = await http.get(url);
    final movieSearch = SearchResponse.fromRawJson(response.body);
    return movieSearch.results;
  }

  //petico de info de l'actor => retorna un CastDetail
  Future<CastDetail> getCastDetail(int castId) async {
    if (actorsById.containsKey(castId)) return actorsById[castId]!;
    
    //Peticio de la info de l'actor
    final jsonData = await _getJson('3/person/$castId');
    final CastDetail actorDetail = CastDetail.fromRawJson(jsonData);
    
    //Peticio de les pelicules en les que ha treballat
    final jsonD = await _getJson('3/person/$castId/combined_credits');
    final CastDetailResponse response = CastDetailResponse.fromRawJson(jsonD);
    List<Movie> tmp = [];
    if (actorDetail.knownForDepartment == 'Directing') {
      tmp = response.crew;
      tmp.sort((a, b) => b.voteCount.compareTo(a.voteCount));
      actorDetail.moviesIn = tmp;
    }
    else {
      tmp = response.cast;
      tmp.sort((a, b) => b.voteCount.compareTo(a.voteCount));
      actorDetail.moviesIn = tmp;
    }
    actorsById[actorDetail.id] = actorDetail;
    return actorDetail;
  }

}