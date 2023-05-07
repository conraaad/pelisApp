
import 'package:flutter/material.dart';
import 'package:pelicules_app/models/models.dart';

class MovieSlider extends StatefulWidget {

  final List<Movie> movieList;
  final String? sliderTitle;
  final Function onNextPage;

  const MovieSlider({super.key, required this.movieList, this.sliderTitle, required this.onNextPage});

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      //print(scrollController.position.pixels);
      if (scrollController.position.pixels + 300 >= scrollController.position.maxScrollExtent) widget.onNextPage();
    });

  }


  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      width: double.infinity,
      height: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.sliderTitle != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(widget.sliderTitle!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),

          Expanded(
            child: ListView.builder(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: widget.movieList.length,
              itemBuilder: (context, index) {
                Movie movie = widget.movieList[index];
                movie.heroId = 'slider-id: ${movie.id}';
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
          Text(movie.getTitle, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, maxLines: 2, style: const TextStyle(fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}