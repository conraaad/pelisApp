
import 'package:flutter/material.dart';

import 'package:pelicules_app/screens/screens.dart';

//classe que ens serveix per tenir les rutes molt més netes, modularitat del codi

abstract class AppRoutes {
  static const initialRoute = 'home';

  /*

  static final menuOptions = <MenuOption>[
    MenuOption(route: 'listView', name: 'ListView', icon: Icons.list_sharp, screen: const Listview2Screen()),
    MenuOption(route: 'alerts', name: 'Alerts', icon: Icons.add_alert, screen: const AlertScreen()),
    MenuOption(route: 'cards', name: 'Cards - Targetes', icon: Icons.credit_card, screen: const CardScreen()),
    MenuOption(route: 'avatar', name: 'Avatar Circle', icon: Icons.person, screen: const AvatarScreen()),
    MenuOption(route: 'animated', name: 'Animated Container', icon: Icons.play_circle, screen: const AnimatedScreen()),
    MenuOption(route: 'inputs', name: 'Text Inputs', icon: Icons.input_rounded, screen: const InputsScreen()),
    MenuOption(route: 'slider', name: 'Slider and Checkbox', icon: Icons.check_box, screen: const SliderScreen()),
    MenuOption(route: 'listviewbuilder', name: 'Infinite Scroll', icon: Icons.wallpaper_outlined, screen: const ListViewBuilderScreen()),

  ];

  */

  //El tema rutes es pot fer perfectament aixi
  
  static Map<String, Widget Function(BuildContext)> routes = {
    'home': (BuildContext context) => const HomeScreen(),
    'detail': (BuildContext context) => const DetailScreen(),
    'castDetail': (BuildContext context) => const CastDetailScreen(),
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