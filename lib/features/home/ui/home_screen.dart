import 'package:flutter/material.dart';
import 'package:movies/features/home/ui/movie_card_list.dart';
import '../../../data/constants.dart';
import '../../../data/network/api_service.dart';
import '../../../data/model/trending_movies.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final List<Future<List<Results>>> moviesSectionList = [];
  final List<String> moviesSectionTitleList = ['Trending Movies','Upcoming Movies','Playing Now','Popular Movies'];

  @override
  void initState() {
    super.initState();
    moviesSectionList.add(ApiService().fetchMoviesByUrl(trendingUrl));
    moviesSectionList.add(ApiService().fetchMoviesByUrl(upComingUrl));
    moviesSectionList.add(ApiService().fetchMoviesByUrl(playingNowUrl));
    moviesSectionList.add(ApiService().fetchMoviesByUrl(popularUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Movie Master',style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold
        ),),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: List.generate(moviesSectionList.length, (index) =>
                movieSection(index)
            ),
          ),
        ),
      ),
    );
  }

  Widget movieSection(int itemIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          moviesSectionTitleList[itemIndex],
          style: const TextStyle(
              fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          child: FutureBuilder(
            future: moviesSectionList[itemIndex],
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else if (snapshot.hasData) {
                return  MovieCardList(snapshot: snapshot,);
              } else {
                return Container();
              }
            },
          ),
        ),

        const SizedBox(height: 12),
      ],
    );
  }
}