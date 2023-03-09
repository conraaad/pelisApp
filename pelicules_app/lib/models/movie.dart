//Model de cada pelicula

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  Movie({
    required this.adult,
    this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    this.originalTitle, //Abans no estava aixi
    required this.overview,
    required this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,  //Abans no estava aixi
    this.video,
    required this.voteAverage,
    required this.voteCount,
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

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
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
  );
}
