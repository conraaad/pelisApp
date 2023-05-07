
import 'dart:convert';

import 'package:pelicules_app/models/models.dart';

class CastDetailResponse {
  
  //Pelicules que ha fet subjecte amb tal id com a actor
  List<Movie> cast;
  ////Pelicules que ha fet subjecte amb tal id com a crew
  List<Movie> crew;
  int id;

  CastDetailResponse({
    required this.cast,
    required this.crew,
    required this.id,
  });

  factory CastDetailResponse.fromRawJson(String str) => CastDetailResponse.fromJson(json.decode(str));

  factory CastDetailResponse.fromJson(Map<String, dynamic> json) => CastDetailResponse(
    cast: List<Movie>.from(json["cast"].map((x) => Movie.fromJson(x))),
    crew: List<Movie>.from(json["crew"].map((x) => Movie.fromJson(x))),
    id: json["id"],
  );

  void filterCastList() {
    for (int i = cast.length - 1; i >= 0; i--) {
      if (cast[i].title == null || cast[i].posterPath == null) cast.removeAt(i);
    }
    for (int i = crew.length - 1; i >= 0; i--) {
      if (crew[i].title == null || crew[i].posterPath == null) crew.removeAt(i);
    }
  }
}
