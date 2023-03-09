//Model per rebre la data que ens subministra el nostre provider
//Aquest model modela les dades que es reben de de la peticio movies now playing

import 'dart:convert';

import 'package:pelicules_app/models/models.dart';

class NowPlayingResponse {

  int page;
  List<Movie> results;
  int totalPages;
  int totalResults;

  NowPlayingResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  //aqui estem construint (d'aqui la key word factory) un constructor amb nom que ens servira pq la classe tingui mes funcionalitats 

  factory NowPlayingResponse.fromRawJson(String str) => NowPlayingResponse.fromJson(json.decode(str));

  factory NowPlayingResponse.fromJson(Map<String, dynamic> json) => NowPlayingResponse(
    page: json["page"],
    results: List<Movie>.from(json["results"].map((x) => Movie.fromJson(x))),
    totalPages: json["total_pages"],
    totalResults: json["total_results"],
  );
}
