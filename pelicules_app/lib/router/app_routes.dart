
import 'package:flutter/material.dart';

import 'package:pelicules_app/screens/screens.dart';

//classe que ens serveix per tenir les rutes molt més netes, modularitat del codi

abstract class AppRoutes {
  static const initialRoute = 'home';

  //El tema rutes es pot fer perfectament aixi
  
  static Map<String, Widget Function(BuildContext)> routes = {
    'home': (BuildContext context) => const HomeScreen(),
    'detail': (BuildContext context) => const DetailScreen(),
    'castDetail': (BuildContext context) => const CastDetailScreen(),
    'watchList' : (BuildContext context) => const WatchListScreen(),
  };

  //Pero el que farem sera crear una funcio que crei el mapa de forma dinamica en funcio de la 
  //nostra llista de MenuOptions

  /*

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {'home': (context) => const HomeScreen()};
    for (MenuOption option in menuOptions) {
      appRoutes.addAll({option.route : (BuildContext context) => option.screen});
    }
    return appRoutes;
  }

  */

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const HomeScreen()
    );
  }
}