
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pelicules_app/models/models.dart';
import 'package:pelicules_app/providers/movies_provider.dart';

class CastSlider extends StatelessWidget {

  final int movieId;

  const CastSlider({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    //Serveix per construir un widget a l'arribada d'un future
    //aqui disparo aquest future que fa la peticio http dels actors
    return FutureBuilder(
      future: moviesProvider.getMovieCast(movieId),
      //snapshot per saber si ja arribat la data
      builder: (BuildContext context, AsyncSnapshot<List<Cast>> snapshot) {
        
        if (!snapshot.hasData) {
          return Container(
            height: 320,
            constraints: const BoxConstraints(maxWidth: 150),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final List<Cast> cast = snapshot.data!;

        return Container(
          width: double.infinity,
          height: 320,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Repartiment', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),

              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: cast.length,
                  itemBuilder: (context, index) => _ActorsPoster(cast[index]),
                ),
              )
            ],
          ),
        );
      }
    );
    
  }
}

class _ActorsPoster extends StatelessWidget {

  final Cast cast;

  const _ActorsPoster(this.cast);

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
              if (cast.profilePath != null) Navigator.pushNamed(context, 'castDetail', arguments: cast.id);
            },
            child: Hero(
              tag: 'cast-id: ${cast.name}-${cast.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/loading_Blue.gif'), 
                  image: NetworkImage(cast.fullImgUrl),
                  width: double.infinity,
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          //Textoverflow ellipsis es pq surtin els tipics tres puntets de hi ha mes text
          Column(
            children: [
              Text(cast.name, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, maxLines: 2, style: const TextStyle(fontWeight: FontWeight.bold),),
              if (cast.character != null)
                const Text('com a', overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, maxLines: 2),
                Text(cast.character!, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, maxLines: 1, style: const TextStyle(fontWeight: FontWeight.bold),),
            ],
          )
        ],
      ),
    );
  }
}