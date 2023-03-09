
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart' show Swiper, SwiperLayout;

import 'package:pelicules_app/models/movie.dart';

class CardSwiper extends StatelessWidget {

  final List<Movie> movieList;

  const CardSwiper({super.key, required this.movieList});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      height: size.height * 0.6,    //60% de la pantalla segons dispositiu
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            alignment: Alignment.centerLeft,
            child: const Text('Ara en cinemes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          
          Swiper(
            itemCount: movieList.length,
            layout: SwiperLayout.STACK,
            itemWidth: size.width * 0.7,
            itemHeight: size.height * 0.49,
            itemBuilder: (context, index) {

              movieList[index].heroId = 'swiper-id: ${movieList[index].id}';

              return GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'detail', arguments: movieList[index]),
                child: Hero(
                  tag: movieList[index].heroId!,
                  child: Card(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    clipBehavior: Clip.antiAlias,
                    child: FadeInImage(
                      fit: BoxFit.fill,
                      placeholder: const AssetImage('assets/loading_Blue.gif'),
                      image: NetworkImage(movieList[index].fullImgUrl)
                    ),
                  ),
                ),
              );

            }
            
          ),
        ],
      ),
    );
  }
}