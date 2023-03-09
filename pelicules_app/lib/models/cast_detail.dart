
import 'dart:convert';

import 'package:pelicules_app/models/models.dart';

class CastDetail {
  List<String> alsoKnownAs;
  String biography;
  String birthday;
  String? deathday;
  int gender;
  String? homepage;
  int id;
  String imdbId;
  String knownForDepartment;
  String name;
  String? placeOfBirth;
  double popularity;
  String? profilePath;

  //pelicules en les que el cast ha participat
  List<Movie> moviesIn = [];

  CastDetail({
    required this.alsoKnownAs,
    required this.biography,
    required this.birthday,
    this.deathday,
    required this.gender,
    this.homepage,
    required this.id,
    required this.imdbId,
    required this.knownForDepartment,
    required this.name,
    this.placeOfBirth,
    required this.popularity,
    this.profilePath,
  });

  get fullImgUrl {
    if (profilePath != null) return "https://image.tmdb.org/t/p/w500$profilePath";
    return "https://i.stack.imgur.com/GNhxO.png";
  }

  get birthdayText {
    return _getDatePhrase(birthday);
  }

  get ageText {
    if (deathday != null) return _getActualAge(birthday, true, deathday!);
    return _getActualAge(birthday, false);
  }

  //PRE: String Data format => aaaa-mm-dd
  //POST: llista de strings [dia, mes, any]
  List<String> splitDate(String date) {
    List<String> tmp = [];
    tmp.add(date.substring(8, 10));
    tmp.add(date.substring(5, 7));
    tmp.add(date.substring(0, 4));
    return tmp;
  }

  //PRE: String Data format => aaaa-mm-dd
  //POST: Retorna la frase ben escrita en català
  String _getDatePhrase(String str) {
    List<String> date = splitDate(str);
    
    final List<String> months = ['gener', 'febrer', 'març', 'abril', 'maig', 'juny', 'juliol', 'agost', 'setembre', 'octubre', 'novembre', 'desembre'];
    String month = '';
    for (int i = 0; i < int.parse(date[1]); i++) {
      month = months[i];
    }
    if (date[0].substring(0,1) == '0') date[0] = date[0].substring(1);
    if (month == 'abril' || month == 'agost' || month == 'octubre') return '${date[0]} d\'$month de ${date[2]}';
    return '${date[0]} de $month de ${date[2]}';
  }

  //PRE: String Data format => aaaa-mm-dd && dead bool (si dead=true => String data deadDate)
  //Retorna un text explicant l'edat que te, si esta mort la que tenia quan va morir
  String _getActualAge(String str, bool dead, [String deadDate = '']) {
    //current day
    List<String> cDate = [];
    if (!dead) {
      cDate = splitDate(DateTime.now().toString());
    }
    else {
      cDate = splitDate(deadDate);
    }
    
    //birthday
    List<String> birth = splitDate(str);
    
    int age = int.parse(cDate[2]) - int.parse(birth[2]);
    if (int.parse(birth[1]) > int.parse(cDate[1])) {
      age--;
    }
    else if (int.parse(cDate[1]) == int.parse(birth[1])) {
      if (int.parse(birth[0]) > int.parse(cDate[0])) {
        age--;
      }
    }
    
    if (dead) return 'Morí el ${_getDatePhrase(deadDate)} ($age anys)';
    return '$age anys';
  }

  factory CastDetail.fromRawJson(String str) => CastDetail.fromJson(json.decode(str));

  factory CastDetail.fromJson(Map<String, dynamic> json) => CastDetail(
    alsoKnownAs: List<String>.from(json["also_known_as"].map((x) => x)),
    biography: json["biography"],
    birthday: json["birthday"],
    deathday: json["deathday"],
    gender: json["gender"],
    homepage: json["homepage"],
    id: json["id"],
    imdbId: json["imdb_id"],
    knownForDepartment: json["known_for_department"],
    name: json["name"],
    placeOfBirth: json["place_of_birth"],
    popularity: json["popularity"]?.toDouble(),
    profilePath: json["profile_path"],
  );
}
