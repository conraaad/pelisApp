import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pelicules_app/providers/movies_provider.dart';
import 'package:pelicules_app/search/search_delegate.dart';
import 'package:pelicules_app/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
   
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    //No volem una altra instancia de la classe MoviesProvider, volem la que hem fet a l'inici, per aixo en aquesta linia el que fem es anar a
    //l'abre de widgets amb el context i buscar el provider MovieProvider, per aixo s'ha de crear el provider amb el ChangeNotifierProvider
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Icon(Icons.movie_creation_outlined, size: 50),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_outlined),
            padding: const EdgeInsets.only(right: 5),
            onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate()), 
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Scroll lateral de cartes  
            CardSwiper(movieList: moviesProvider.onDisplayMovies),

            const SizedBox(height: 20),

            MovieSlider(
              movieList: moviesProvider.topRatedMovies, 
              sliderTitle: 'Les més valorades',
              onNextPage: moviesProvider.getTopRatedMovies,          //aqui estem enviant la funcio del provider, de manera que des del widget es pugui fer una peticio http
            ),

            //Scroll lateral de pelis
            MovieSlider(
              movieList: moviesProvider.popularMovies, 
              sliderTitle: 'Populars',
              onNextPage: moviesProvider.getPopularMovies,          //aqui estem enviant la funcio del provider, de manera que des del widget es pugui fer una peticio http
            ),
            const SizedBox(height: 50,),
          ],
        ),
      )
    );
  }
}