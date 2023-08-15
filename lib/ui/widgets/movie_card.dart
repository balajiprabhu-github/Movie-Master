import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';


class MovieCard extends StatefulWidget {
  const MovieCard({super.key});

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  @override
  Widget build(BuildContext context) {
    return movieCard(context);
  }

  Widget movieCard(BuildContext context) {
    return Container(
      width: 140,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.background),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Stack(clipBehavior: Clip.none, children: <Widget>[
            cardBackGround(),
            cardGradient(context),
          ]),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              movieTitle(context),
              movieRating(context)
            ],
          )
        ],
      ),
    );
  }

  Widget cardGradient(BuildContext context) {
    return Container(
      height: 180.0,
      width: 140.0,
      decoration: BoxDecoration(
          color: Colors.white,
          gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: [
                Theme.of(context)
                    .colorScheme
                    .surface
                    .withOpacity(0.0),
                Theme.of(context).colorScheme.surface,
              ],
              stops: const [
                0.0,
                1.0
              ])),
    );
  }

  Widget cardBackGround() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: NetworkImage(
              "https://image.tmdb.org/t/p/w500/gD72DhJ7NbfxvtxGiAzLaa0xaoj.jpg"),
        ),
      ),
      height: 180.0,
      width: 140.0,
    );
  }

  Widget movieTitle(BuildContext context) {
    return const SizedBox(
      width: 70,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('Heart of Dragon'),
      ),
    );
  }

  Widget movieRating(BuildContext context) {
    return SizedBox(
      width: 70,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircularPercentIndicator(
          radius: 20,
          lineWidth: 6,
          backgroundColor: Colors.grey,
          progressColor: Colors.red,
          percent: 0.6,
          center: Text(
            "60%",
            style: TextStyle(fontSize: 10,color: Theme.of(context).colorScheme.primary),
          ),
          circularStrokeCap: CircularStrokeCap.round,
          animation: false,
          animationDuration: 2000,
        ),
      ),
    );
  }
}


