
import 'package:flutter/material.dart';
import 'package:pelicules_app/models/models.dart';
import 'package:provider/provider.dart';

import 'package:pelicules_app/providers/saved_movies_provider.dart';
import 'package:pelicules_app/themes/app_theme.dart';

class SavedMoviesListView extends StatelessWidget {
  const SavedMoviesListView({super.key});

  @override
  Widget build(BuildContext context) {
    final savedMoviesProvider = Provider.of<SavedMoviesProvider>(context);
    Container noEmpty = Container();

    final inCaseEmpty = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.movie_creation_rounded, size: 80, color: Colors.black54),
          SizedBox(height: 10),
          Text('No hi ha pel·lícules guardades', style: TextStyle(fontSize: 20, color: Colors.black54))
        ],
      )
    );

    if (!savedMoviesProvider.empty) {

      noEmpty = Container(
        width: double.infinity,
        height: double.infinity,
        //color: Colors.red,

        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: savedMoviesProvider.savedMoviesList.length,
            itemBuilder: (context, index) => _SavedMovieCard(savedMoviesProvider.savedMoviesList[index]),
          ),
        ),
      );
    }


    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.mainColor, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )
      ),
      //get data del storage
      child: savedMoviesProvider.empty ? inCaseEmpty : noEmpty,
    );
  }
}

//Idea sobre estetica => molaria molt agafar el color dominant de la foto i extendre un linear gradient per sota
//a la conta de gpt esta una opcio de com fer-ho

class _SavedMovieCard extends StatelessWidget {

  final Movie movie;

  const _SavedMovieCard(this.movie);

  /* List<double> getTitlesFontSizes() {
    
  } */

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 160,
      child: GestureDetector(
        onTap: () {
          if (movie.title != null) {
            movie.heroId = "fromSaved - ${movie.title}, ${movie.id}";
            Navigator.pushNamed(context, 'detail', arguments: movie);
          }
        },
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          clipBehavior: Clip.antiAlias,
          elevation: 20,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Color.fromARGB(255, 223, 204, 204)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            ),
            child: Row(
              children: [
                SizedBox(
                  height: double.infinity,
                  width: 120,
                  child: ClipRect(
                    child: FadeInImage(
                      placeholder: const AssetImage("assets/loading_Blue.gif"), 
                      image: NetworkImage(movie.fullImgUrl),
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
          
                const SizedBox(width: 20),
          
                SizedBox(
                  width: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [ 
                      Text(movie.title ?? "no-title", style: const TextStyle(fontSize: 22), overflow: TextOverflow.ellipsis, maxLines: 2), 
                      const SizedBox(height: 10),
                      Text(movie.originalTitle ?? "no-title", style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic), overflow: TextOverflow.ellipsis, maxLines: 2) 
                    ]),
                ),
                
              ]),
          ),
        )
      )
    );
  }
}


/* child: FutureBuilder(
        future: savedMoviesProvider.loadFromStorage(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (savedMoviesProvider.empty) {
            return Center(child: Row(children: const [
              Icon(Icons.movie_creation_rounded),
              Text('No hi ha pel·lícules guardades')
            ],));
          }

          return Container();
        },
      ),
       */