//Model de cada pelicula

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pelicules_app/helpers/helpers.dart';
import 'package:pelicules_app/providers/saved_movies_provider.dart';
import 'package:pelicules_app/providers/movies_provider.dart';

class Movie {

  bool adult;
  String? backdropPath;
  List<int> genreIds;
  int id;
  String originalLanguage;
  String? originalTitle;
  String overview;
  double popularity;
  String? posterPath;
  String? releaseDate;
  String? title;
  bool? video;
  double voteAverage;
  int voteCount;

  String? heroId;
  bool saved;

  Movie({
    required this.adult,
    this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    this.originalTitle,
    required this.overview,
    required this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title, 
    this.video,
    required this.voteAverage,
    required this.voteCount,
    this.saved = false,
  });


  get fullImgUrl {
    if (posterPath != null) return "https://image.tmdb.org/t/p/w500$posterPath";
    return "https://i.stack.imgur.com/GNhxO.png";
  }

  get fullBackdrop {
    if (backdropPath != null) return 'https://image.tmdb.org/t/p/w500$backdropPath';
    return fullImgUrl;
  }

  get releaseYear {
    return releaseDate != null ? releaseDate!.substring(0, 4) : null;
  }

  String getMovieGenres(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);
    String defGenres = '${moviesProvider.genres[genreIds[0]]}';

    for (int i = 1; i < genreIds.length; i++) {
      defGenres = '$defGenres, ${moviesProvider.genres[genreIds[i]]}';
    }
    return defGenres;
  }

  factory Movie.fromRawJson(String str) => Movie.fromJson(json.decode(str));

  //TODO: HAIG DE MIRAR QUE CADA VEGADA QUE ES CREI UNA MOVIE JA NO EXISTEIXI A LA LLISTA DE GUARDADES

  factory Movie.fromJson(Map<String, dynamic> json) {
    //si true, la movie esta guardada a la llista, per tant necessitem retornar la instancia ja creada
    final p = Movie.isMovieSaved(AppContext.getContext(), json);
    if (p.first) {
      return p.second!;
    } 
    else {
      return Movie(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"]?.toDouble(),
        posterPath: json["poster_path"],
        releaseDate: json["release_date"],
        title: json["title"],
        video: json["video"],
        voteAverage: json["vote_average"]?.toDouble(),
        voteCount: json["vote_count"],
        saved: json["saved"] ?? false
      );
    }
  }

  //JSON encodable per fer internal storage
  Map<String, dynamic> toJsonEncodable() => {
    "adult": adult,
    "backdrop_path": backdropPath,
    "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
    "id": id,
    "original_language": originalLanguage,
    "original_title": originalTitle,
    "overview": overview,
    "popularity": popularity,
    "poster_path": posterPath,
    "release_date": releaseDate,
    "title": title,
    "video": video,
    "vote_average": voteAverage,
    "vote_count": voteCount,
    "saved": saved
  };

  //Busca una Movie amb id en el json que estigui guardada
  static Pair<bool, Movie?> isMovieSaved(BuildContext context, Map<String, dynamic> json) {
    final savedMoviesProvider = Provider.of<SavedMoviesProvider>(context, listen: false);
    for (int i = 0; i < savedMoviesProvider.savedMoviesList.length; i++) {
      if (savedMoviesProvider.savedMoviesList[i].id == json["id"]) return Pair(true, savedMoviesProvider.savedMoviesList[i]);
    }
    return Pair(false, null);
  }
}
