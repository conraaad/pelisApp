
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pelicules_app/models/models.dart';
import 'package:pelicules_app/providers/movies_provider.dart';

class MovieSearchDelegate extends SearchDelegate {

  Widget lastSearch = Container();

  @override
  String get searchFieldLabel => 'Buscar';


  Widget _emptyContainer() {
    return const Center(
      child: Icon(Icons.movie_creation_outlined, color: Colors.black38, size: 130),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        }, 
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        //Serveix per tancar el search delegate, i si es vol es pot enviar alguna cosa
        close(context, null);
      }, 
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return lastSearch;
  }

  //Una manera de fer-ho, sense streams, directament amb un future Builder, problema => estem disparant moltes peticions, amb cada canvi
  //hem de fer un filtratge dels canvis que volem fer 

  /*
  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return _emptyContainer();

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    
    return FutureBuilder(
      future: moviesProvider.searchMovies(query),
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        if (!snapshot.hasData) return _emptyContainer();

        final movieList = snapshot.data!;

        lastSearch = ListView.separated(
          itemCount: movieList.length,
          itemBuilder: (context, index) {
            movieList[index].heroId = 'search-id: ${movieList[index].id}';
            return _MovieItem(movieList[index]);
          },
          separatorBuilder: (_, __) => const Divider(),
        );

        return lastSearch;
      },
    );
  }*/

  //Amb streams

    @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return _emptyContainer();

    //el buildSuggestion s'executa cada vegada que es fa una modificacio en el searchtab, pero el streamBuilder nomes fa el build quan el stream emet algun valor
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    moviesProvider.getSuggestionByQuery(query);

    return StreamBuilder(
      stream: moviesProvider.suggestionStream,
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        if (!snapshot.hasData) return _emptyContainer();

        final movieList = snapshot.data!;

        lastSearch = ListView.separated(
          itemCount: movieList.length,
          itemBuilder: (context, index) {
            movieList[index].heroId = 'search-id: ${movieList[index].id}';
            return _MovieItem(movieList[index]);
          },
          separatorBuilder: (_, __) => const Divider(),
        );

        return lastSearch;
      },
    );
  }

}

class _MovieItem extends StatelessWidget {

  final Movie movie;

  const _MovieItem(this.movie);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: FadeInImage(
        placeholder: const AssetImage('assets/no-image.jpg'), 
        image: NetworkImage(movie.fullImgUrl),
        width: 50,
        fit: BoxFit.contain,
      ),
      title: Text(movie.title ?? 'No original title', style: const TextStyle(fontSize: 18)),
      subtitle: Text(movie.originalTitle ?? 'No original title'),
      onTap: () => Navigator.pushNamed(context, 'detail', arguments: movie),
    );
  }
}