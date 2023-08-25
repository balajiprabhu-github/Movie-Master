import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/features/home/bloc/home_bloc.dart';
import 'package:movies/features/home/data/movie_section_data.dart';
import '../../../repository/constants.dart';
import '../../movies_details/ui/movie_details_screen.dart';

class MovieCardList extends StatelessWidget {

  MovieCardList({
    super.key,
    required this.movieSection,
  });

  final MovieSectionData movieSection;

  final HomeBloc homeBloc = HomeBloc();

  @override
  Widget build(BuildContext context) {

    return BlocListener<HomeBloc, HomeState>(
      bloc: homeBloc,
      listener: (context, state) {
       if(state is HomeOnMovieCardItemClickState) {
         Navigator.push(
           context,
           MaterialPageRoute(builder: (context) => MovieDetailsScreen(results:movieSection.movieResultsList[state.itemIndex])),
         );
       }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            movieSection.sectionTitle.toString(),
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: movieSection.movieResultsList.length,
              itemBuilder: (context, itemIndex) {
                return movieCard(context, itemIndex);
              },
              separatorBuilder: (context, int index) {
                return const SizedBox(width: 10,);
              },),
          ),

          const SizedBox(
            height: 20,
          ),

        ],
      ),
    );
  }

  Widget movieCard(BuildContext context, int itemIndex) {
    var result = movieSection.movieResultsList[itemIndex];
    return InkWell(
      onTap: () {
        homeBloc.add(HomeOnMovieCardItemClickEvent(itemIndex: itemIndex));
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
              cardBackGround(result.posterPath.toString()),
            ]),
          ],
        ),
      ),
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
}
