import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pelicules_app/providers/movies_provider.dart';
import 'package:pelicules_app/providers/saved_movies_provider.dart';

import 'package:pelicules_app/models/models.dart';
import 'package:pelicules_app/themes/app_theme.dart';
import 'package:pelicules_app/widgets/widgets.dart';

class DetailScreen extends StatefulWidget {
   
  const DetailScreen({Key? key}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {

    //manera de rebre els arguments que s'envien mitjançant els args del navigator
    final Movie movie = ModalRoute.of(context)?.settings.arguments as Movie;

    int favoriteOption;
    movie.saved ? favoriteOption = 1 : favoriteOption = 0;
    const List<Icon> favoriteIcons = [Icon(Icons.favorite_border_rounded, size: 30), Icon(Icons.favorite_rounded, color: Colors.red, size: 30)];
    
    return Scaffold(
      body: CustomScrollView(
        //Els slivers son widgets que tenen un comportament preprogramat quan es fa scroll, rollo minimitzar-se, fer-se petit, etc
        //Problema => tot el que vagi en aquesta llista ha de ser un sliver
        //physics: BouncingScrollPhysics(),
        slivers: [
          _CustomAppBar(movie.fullBackdrop, movie.title ?? 'No original title'),

          //Aquests dos widgets ens serveixen per seguir posant widgets normals barrejats amb els slivers
          SliverList(
            delegate: SliverChildListDelegate([
              _PosterAndTitle(movie),
              _MovieDescription(movie.overview),
              const SizedBox(height: 30),
              CastSlider(movieId: movie.id),
              const SizedBox(height: 30)
            ]),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            final savedMoviesProvider = Provider.of<SavedMoviesProvider>(context, listen: false);
            if (!movie.saved) {
              movie.saved = true;
              savedMoviesProvider.addMovie(movie);
            }
            else {
              movie.saved = false;
              savedMoviesProvider.delMovie(movie);
            }
            favoriteOption = 1 - favoriteOption;
          });
        },
        child: favoriteIcons[favoriteOption]
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}

//Sliver AppBar => titol de la pelicula amb fons del wallpaper d'aquesta

class _CustomAppBar extends StatelessWidget {

  final String moviePosterUrl;
  final String title;

  const _CustomAppBar(this.moviePosterUrl, this.title);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppTheme.mainColor,
      expandedHeight: 350,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          color: Colors.black12,
          child: Text(title, style: const TextStyle(fontSize: 16,), textAlign: TextAlign.center,)
        ),

        background: FadeInImage(
          placeholder: const AssetImage('assets/loading.gif'), 
          image: NetworkImage(moviePosterUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}


//Part de sota de la pantalla details_screen => info sobre la pelicula

class _PosterAndTitle extends StatelessWidget {

  final Movie movie;

  const _PosterAndTitle(this.movie);

  String _getDirector(List<Cast> crewList) {
    String directors = '';
    int currrentInd = 0;
    for (int i = 0; i < crewList.length; i++) {
      if (crewList[i].job == 'Director') { 
        directors = crewList[i].name;
        currrentInd = i;
        break;
      }
    }

    for (int i = currrentInd + 1; i < crewList.length; i++) {
      if (crewList[i].job == 'Director') { 
        directors = '$directors, ${crewList[i].name}';
      }
    }
    
    return directors;
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final String genres = movie.getMovieGenres(context);

    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Container(
      padding: const EdgeInsets.only(top: 20),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'), 
                image: NetworkImage(movie.fullImgUrl),
                height: 200,
              ),
            ),
          ),

          const SizedBox(width: 20),

          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width - 210),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //titol
                Text(movie.title ?? 'No original title', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 2),
                const SizedBox(height: 5),
                //Original title
                Text(movie.originalTitle ?? 'No original title', style: const TextStyle(fontSize: 17), overflow: TextOverflow.ellipsis, maxLines: 2),
                const SizedBox(height: 15),
                //releaseYear
                if (movie.releaseYear != null)
                  Text(movie.releaseYear!, style: const TextStyle(fontSize: 18), overflow: TextOverflow.ellipsis, maxLines: 2),
                  const SizedBox(height: 5),
                //genres
                Text(genres, style: const TextStyle(fontSize: 18), overflow: TextOverflow.ellipsis, maxLines: 2),
                const SizedBox(height: 5),

                //Director
                FutureBuilder(
                  future: moviesProvider.getMovieCrew(movie.id),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if(snapshot.hasData) {
                      final String director = _getDirector(snapshot.data);
                      return Text('Dirigida per: $director', style: const TextStyle(fontSize: 18), overflow: TextOverflow.ellipsis, maxLines: 2);
                    }
                    return Container();
                    
                  },
                ),
                const SizedBox(height: 5),


                Row(
                  children: [
                    const Icon(Icons.star),
                    const SizedBox(width: 5),
                    Text(movie.voteAverage.toString(), style: Theme.of(context).textTheme.bodySmall,)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _MovieDescription extends StatelessWidget {

  final String description;

  const _MovieDescription(this.description);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Text(
        description,
        textAlign: TextAlign.justify,
        style: const TextStyle(fontSize: 17),
      ),
    );
  }
}