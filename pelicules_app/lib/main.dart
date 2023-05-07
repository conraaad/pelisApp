import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pelicules_app/providers/movies_provider.dart';
import 'package:pelicules_app/providers/saved_movies_provider.dart';

import 'package:pelicules_app/router/app_routes.dart';
import 'package:pelicules_app/themes/app_theme.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //Aqui estem fent servir el nostre provider => lazy: evita que es faci de forma lazy, es a dir si no li diem que false, nomes s'instanciaria
        //quan algun widget ho necessiti, nosaltres necessitem que quedi instanciada ben amunt del context, de l'abre de widgets
        ChangeNotifierProvider(create: (context) => SavedMoviesProvider(context), lazy: false),
        ChangeNotifierProvider(create: (context) => MoviesProvider(context), lazy: false),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      routes: AppRoutes.routes,
      initialRoute: AppRoutes.initialRoute,
      //onGenerateRoute: (settings) => AppRoutes.onGenerateRoute(settings),
      onGenerateRoute: AppRoutes.onGenerateRoute,
      theme: AppTheme.lightTheme,
    );
  }
}