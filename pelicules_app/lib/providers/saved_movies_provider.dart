
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import 'package:pelicules_app/helpers/helpers.dart';
import 'package:pelicules_app/models/models.dart';

class SavedMoviesProvider extends ChangeNotifier {
  
  BuildContext context;
  final LocalStorage _storage = LocalStorage('saved_movies.json');
  bool empty = true;
  List<Movie> savedMoviesList = [];
  
  SavedMoviesProvider(this.context){
    //For debugging
    //clearStorage();
    _loadFromStorage();
  }

  //PÚBLIQUES

  //PRE: La pelicula movie no es troba en la llista savedMoviesList
  //POST: Afegeix la pelicula movie a la llista savedMoviesList
  void addMovie(Movie movie) {
    movie.saved = true;
    savedMoviesList.add(movie);
    empty = false;
    _saveToStorage();
  }

  //PRE: la pelicula es troba guardada a la llista
  //POST: Elimina de la llista de pelis guardades la pelicula movie
  void delMovie(Movie movie) {
    movie.saved = false;
    int i;
    for (i = 0; i < savedMoviesList.length; i++) {
      if (savedMoviesList[i].id == movie.id) break;
    }
    savedMoviesList.removeAt(i);
    if (savedMoviesList.isEmpty) {
      empty = true;
      clearStorage();
    }
    else {
      _saveToStorage();
    }
  }

  //PRE: cert
  //POST: Buida l'storage de manera que es seteja a null
  void clearStorage() async {
    await _storage.ready;
    for (int i = 0; i < savedMoviesList.length; i++) {
      savedMoviesList[i].saved = false;
    }
    await _storage.clear();
    savedMoviesList = [];
    empty = true;
    notifyListeners();
  }

  //Fa un reload del què hi ha al storage i ho porta a la llista de pelicules
  void _loadFromStorage() async {
    await _storage.ready;
    final List<dynamic>? savedData = _storage.getItem('saved_movies');
    print(savedData == null ? "SavedData: null" : "SavedData: not null");
    print("Saved Data al LOAD: $savedData");
    if (savedData != null) {
      empty = false;
      savedMoviesList = savedData.map((data) => Movie.fromJson(data)).toList();
      notifyListeners();
    }
  }

  //PRE: cert
  //POST: retorna un Pair<bool, Movie> => true si la pelicula amb ID: id esta a la llista de guardades
  Pair<bool, Movie?> getMovieSavedById(int id) {
    for (int i = 0; i < savedMoviesList.length; i++) {
      if (savedMoviesList[i].id == id) return Pair(true, savedMoviesList[i]);
    }
    return Pair(false, null);
  }

  List<dynamic> _getFullJson() {
    return savedMoviesList.map((elem) {
      return elem.toJsonEncodable();
    }).toList();
  }

  void _saveToStorage() {
    _storage.setItem('saved_movies', _getFullJson());
    notifyListeners();
  }
}

