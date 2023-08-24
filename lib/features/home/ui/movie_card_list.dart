import 'package:flutter/material.dart';
import 'package:movies/features/movies_details/ui/movie_details_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../data/constants.dart';

class MovieCardList extends StatefulWidget {
  const MovieCardList({
    super.key,
    required this.snapshot,
  });

  final AsyncSnapshot snapshot;

  @override
  State<MovieCardList> createState() => _MovieCardListState();
}

class _MovieCardListState extends State<MovieCardList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: widget.snapshot.data!.length,
        itemBuilder: (context, itemIndex) {
          return movieCard(context, itemIndex);
        },
        separatorBuilder: (context, int index) {
          return const SizedBox(width: 10,);
        },),
    );
  }

  Widget movieCard(BuildContext context, int itemIndex) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MovieDetailsScreen(results:widget.snapshot.data[itemIndex])),
        );
      },
      child: Container(
        height: 200,
        width: 140,
        decoration: BoxDecoration(color: Theme
            .of(context)
            .colorScheme
            .background),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(clipBehavior: Clip.none, children: <Widget>[
              cardBackGround(widget.snapshot.data[itemIndex].posterPath),
            ]),
          ],
        ),
      ),
    );
  }

  Widget cardGradient(BuildContext context) {
    return Container(
      height: 200,
      width: 140,
      decoration: BoxDecoration(
          color: Colors.white,
          gradient: LinearGradient(
              begin: FractionalOffset.bottomLeft,
              end: FractionalOffset.topRight,
              colors: [
                Colors.transparent,
                Theme
                    .of(context)
                    .colorScheme
                    .surface,
              ],
              stops: const [
                0.0,
                1.3
              ])),
    );
  }

  Widget cardBackGround(String posterPath) {
    return Container(
      height: 200,
      width: 140,
      decoration: BoxDecoration(
        color: Colors.transparent,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: NetworkImage(
              "$imageUrl$posterPath"),
        ),
      ),
    );
  }

  Widget movieRating(BuildContext context,int index) {
    return SizedBox(
      width: 45,
      child: CircularPercentIndicator(
        radius: 20,
        lineWidth: 6,
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        progressColor: movieRatingProgressColor(widget.snapshot.data[index].voteAverage),
        percent: movieRatingPercentage(widget.snapshot.data[index].voteAverage),
        center: Text(
          movieRatingPercentageLabel(widget.snapshot.data[index].voteAverage),
          style: TextStyle(fontSize: 10, color: Theme
              .of(context)
              .colorScheme
              .onSurface),
        ),
        circularStrokeCap: CircularStrokeCap.round,
        animation: false,
        animationDuration: 2000,
      ),
    );
  }

  double movieRatingPercentage(num voteAverage) {
    return voteAverage/10;
  }

  String movieRatingPercentageLabel(num voteAverage) {
    int percentageValue = (voteAverage * 10).toInt();
    return '$percentageValue%';
  }

  Color movieRatingProgressColor(num voteAverage) {
    final sealedVoteAverage = voteAverage.toInt();
    if(sealedVoteAverage >= 7) {
      return Colors.green;
    } else if(sealedVoteAverage < 7 && sealedVoteAverage > 5) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }
}
