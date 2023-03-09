
import 'dart:convert';

class GenresResponse {
  
  Map<int, String> genres;
  
  GenresResponse({
    required this.genres,
  });


  factory GenresResponse.fromRawJson(String str) => GenresResponse.fromJson(json.decode(str));

  factory GenresResponse.fromJson(Map<String, dynamic> json) {
    Map<int, String> tmp = {};
    for (int i = 0; i < json["genres"].length; i++) {
      tmp.addAll({json["genres"][i]["id"]: json["genres"][i]["name"]});
    }
    return GenresResponse(genres: tmp);
  }

}

