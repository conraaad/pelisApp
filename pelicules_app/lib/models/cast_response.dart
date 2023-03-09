import 'dart:convert';

import 'package:pelicules_app/models/models.dart';

class CastResponse {

  int id;
  List<Cast> cast;
  List<Cast> crew;

  CastResponse({
    required this.id,
    required this.cast,
    required this.crew,
  });

  factory CastResponse.fromRawJson(String str) => CastResponse.fromJson(json.decode(str));

  factory CastResponse.fromJson(Map<String, dynamic> json) => CastResponse(
    id: json["id"],
    cast: List<Cast>.from(json["cast"].map((x) => Cast.fromJson(x))),
    crew: List<Cast>.from(json["crew"].map((x) => Cast.fromJson(x))),
  );
}
