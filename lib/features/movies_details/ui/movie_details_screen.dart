import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/features/movies_details/bloc/movie_details_bloc.dart';
import 'package:movies/features/movies_details/data/movie_details_data.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../di/get_it.dart';
import '../../../repository/Constants.dart';

class MovieDetailsScreen extends StatefulWidget {
  
  final MovieDetailsData movieDetailsData;
  const MovieDetailsScreen({super.key, required this.movieDetailsData});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {

  final MovieDetailsBloc movieDetailsBloc = locator<MovieDetailsBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MovieDetailsBloc, MovieDetailsState>(
      bloc: movieDetailsBloc,
      listener: (context,state) {
        if(state is MovieDetailsOnBackPressState) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).viewPadding.top,
                ),
                movieBackDrop(context),
                const SizedBox(
                  height: 20,
                ),
                movieTitle(),
                movieReleaseYear(),
                const SizedBox(
                  height: 20,
                ),
                movieGenre(),
                movieOverview(),
                movieCrew(),
                movieCast()
              ],
            ),
          ),
        );
      },
    );
  }

  Widget movieTitle() {
    var result = widget.movieDetailsData.results;
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: 240,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            result.title.toString(),
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget movieReleaseYear() {
    var result = widget.movieDetailsData.results;
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: 250,
        child: Text(
          "(${result.releaseDate.toString().substring(0, 4)})",
          textAlign: TextAlign.right,
          style: const TextStyle(
              fontSize: 20, color: Colors.grey, fontStyle: FontStyle.italic),
        ),
      ),
    );
  }

  Widget movieGenre() {
    var genre = widget.movieDetailsData.genresMap;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            'Genre',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            genre.values.join(" • "),
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget movieOverview() {
    var result = widget.movieDetailsData.results;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            'Overview',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            result.overview.toString(),
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget moviePoster(String posterPath) {
    return Card(
      elevation: 8,
      child: Container(
        height: 200,
        width: 140,
        decoration: BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage("$imageUrl$posterPath"),
          ),
        ),
      ),
    );
  }

  Widget movieBackDrop(BuildContext context) {
    var result = widget.movieDetailsData.results;

    return Container(
      height: 300,
      width: double.infinity,
      decoration:
          BoxDecoration(color: Theme.of(context).colorScheme.background),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(clipBehavior: Clip.none, children: <Widget>[
            cardBackGround(result.backdropPath.toString()),
            cardGradient(context),
            Positioned(
                top: 10.0,
                left: 10.0,
                child: GestureDetector(
                  onTap: () {
                    movieDetailsBloc.add(MovieDetailsOnBackPressedEvent());
                  },
                  child: backButton(context),
                )),
            Positioned(
              bottom: -80.0,
              left: 10.0,
              child: moviePoster(result.posterPath.toString()),
            ),
            Positioned(
              bottom: 0.0,
              right: 0.0,
              child: movieRating(context),
            ),
          ]),
        ],
      ),
    );
  }

  Widget backButton(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
      ),
      child: Center(
        child: Icon(
          Icons.arrow_back,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget cardGradient(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: [
                Colors.transparent,
                Theme.of(context).colorScheme.surface,
              ],
              stops: const [
                0.0,
                1.0
              ])),
    );
  }

  Widget cardBackGround(String posterPath) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: NetworkImage("$imageUrl$posterPath"),
        ),
      ),
    );
  }

  Widget movieRating(BuildContext context) {
    var movieRatingData = widget.movieDetailsData.movieRatingData;
    return SizedBox(
      height: 150,
      width: 100,
      child: Center(
        child: CircularPercentIndicator(
          radius: 40,
          lineWidth: 10,
          footer: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "User Score",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.onSurface,
          progressColor: movieRatingData.progressColor,
          percent: movieRatingData.percentage,
          center: Text(
            movieRatingData.percentageLabel,
            style: TextStyle(
                fontSize: 20, color: Theme.of(context).colorScheme.onSurface),
          ),
          circularStrokeCap: CircularStrokeCap.round,
          animation: false,
          animationDuration: 2000,
        ),
      ),
    );
  }

  Widget movieCrew() {
    var directorName = widget.movieDetailsData.directorName;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Crew',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          crewInfo(directorName,'Director'),
        ],
      ),
    );
  }

  Widget crewInfo(String name, String job) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(job)
      ],
    );
  }

  Widget movieCast() {
    var castList = widget.movieDetailsData.castList;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cast',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 150,
            child: Center(
              child: ListView.separated(
                itemBuilder: (snapshot, itemIndex) {
                  return castInfo(itemIndex);
                },
                separatorBuilder: (context, int index) {
                  return const SizedBox(
                    width: 10,
                  );
                },
                itemCount: castList.length,
                scrollDirection: Axis.horizontal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget castInfo(int itemIndex) {
    var cast = widget.movieDetailsData.castList[itemIndex];
    String? imagePath = cast.profilePath;

    if (imagePath != null) {
      return Column(
        children: [
          CircleAvatar(
            radius: 30, // Adjust the radius as needed
            foregroundImage: NetworkImage('$imageUrl$imagePath'),
            backgroundColor: Colors.transparent,
          ),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            width: 100,
            child: Text(
              cast.name.toString(),
              textAlign: TextAlign.center,
            ),
          )
        ],
      );
    }
    return Container();
  }
}
