
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pelicules_app/models/models.dart';
import 'package:pelicules_app/providers/movies_provider.dart';
import 'package:pelicules_app/themes/app_theme.dart';


class CastDetailScreen extends StatelessWidget {
   
  const CastDetailScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    //manera de rebre els arguments que s'envien mitjançant els args del navigator
    final int castId = ModalRoute.of(context)?.settings.arguments as int;
    final MoviesProvider moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      body: FutureBuilder(
        future: moviesProvider.getCastDetail(castId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final CastDetail cast = snapshot.data;

          return CustomScrollView(
            slivers: [
              _CustomAppBar(cast.fullImgUrl, cast.name),

              //Aquests dos widgets ens serveixen per seguir posant widgets normals barrejats amb els slivers
              SliverList(
                delegate: SliverChildListDelegate([
                  _PosterAndTitle(cast),
                  const SizedBox(height: 20),
                  _MovieDescription(cast.biography),
                  const SizedBox(height: 30,),
                  MoviesInSlider(sliderTitle: 'Pel·lícules', list: cast.moviesIn),
                  const SizedBox(height: 30)
                ]),
              )
            ],
          );
          
        },
      ),
    );
  }
}

//Sliver AppBar => nom de l'actor

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


// => info sobre l'actor

class _PosterAndTitle extends StatelessWidget {

  final CastDetail cast;

  const _PosterAndTitle(this.cast);

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.only(top: 20),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            //tag: cast.heroId!,
            tag: 'cast-id: ${cast.name}-${cast.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'), 
                image: NetworkImage(cast.fullImgUrl),
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
                //Nom 
                Text(cast.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 2,),
                const SizedBox(height: 10),
                //Job
                Text(cast.knownForDepartment, style: const TextStyle(fontSize: 18), overflow: TextOverflow.ellipsis, maxLines: 2,),
                const SizedBox(height: 10),
                //BirthDay and BirthPlace
                Text("${cast.birthdayText}, ${cast.getPlaceOfBirth}", style: const TextStyle(fontSize: 18), overflow: TextOverflow.ellipsis, maxLines: 2,),
                const SizedBox(height: 10),
                //Deathday or actual age
                Text(cast.ageText, style: const TextStyle(fontSize: 18), overflow: TextOverflow.ellipsis, maxLines: 2,),
                const SizedBox(height: 10),
                //Popularity
                Row(
                  children: [
                    const Icon(Icons.star),
                    const SizedBox(width: 5),
                    Text(cast.popularity.toString(), style: Theme.of(context).textTheme.bodySmall,)
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

  final String? description;

  const _MovieDescription(this.description);

  @override
  Widget build(BuildContext context) {
    if (description != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Text(
          description!,
          textAlign: TextAlign.justify,
          style: const TextStyle(fontSize: 17),
        ),
      );
    }
    return Container();
  }
}

class MoviesInSlider extends StatelessWidget {

  final String? sliderTitle;
  final List<Movie> list; 

  const MoviesInSlider({super.key, this.sliderTitle, required this.list});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (sliderTitle != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(sliderTitle!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),

          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              itemBuilder: (context, index) {
                Movie movie = list[index];
                movie.heroId = 'castDetail-id: ${movie.id}';
                return _MoviePoster(movie);
              }
            ),
          )
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {

  final Movie movie;

  const _MoviePoster(this.movie);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 190,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          //ClipRRect es similar a una targeta
          GestureDetector(
            onTap: () {
              movie.title != null ? Navigator.pushNamed(context, 'detail', arguments: movie) : null;
            },
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/loading_Blue.gif'), 
                  image: NetworkImage(movie.fullImgUrl),
                  width: double.infinity,
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          //Textoverflow ellipsis es pq surtin els tipics tres puntets de hi ha mes text
          Text(movie.title ?? 'No original title', overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, maxLines: 2)
        ],
      ),
    );
  }
}