import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies/features/home/data/movie_section_data.dart';
import '../constants.dart';
import '../model/genres.dart';
import '../model/trending_movies.dart';

final headers = {
  'Authorization':
  'Bearer $bearerToken',
  'connection': 'keep-alive',
  'Content-Type': 'application/json',
};

class ApiService {

  final http.Client httpClient;

  ApiService(this.httpClient);

  Map<String, String> movieCategories = {
    'Trending Movies': trendingUrl,
    'Upcoming Movies': upComingUrl,
    'Playing Now': playingNowUrl,
    'Popular Movies': popularUrl,
  };

  Future<List<Results>> fetchMoviesByUrl(String url) async {

    final response = await httpClient.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Results.fromJson(movie)).toList();
    } else {
      throw Exception('Something happened');
    }
  }

  Future<List<MovieSectionData>> fetchMovieSectionList() async {

    final List<Future<List<Results>>> resultsFutures = [];

    for (var value in movieCategories.values) {
      resultsFutures.add(fetchMoviesByUrl(value));
    }

    final resultsLists = await Future.wait(resultsFutures);

    final movieSections = <MovieSectionData>[];

    int index = 0;
    for (var category in movieCategories.keys) {
      movieSections.add(MovieSectionData(
        sectionTitle: category,
        movieResultsList: resultsLists[index],
      ));
      index++;
    }

    return movieSections;
  }

  Future<List<Genre>> fetchGenres() async {

    final response = await httpClient.get(Uri.parse(genreUrl), headers: headers);

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['genres'] as List;
      return decodedData.map((genre) => Genre.fromJson(genre)).toList();
    } else {
      throw Exception('Something happened');
    }
  }

  Future<Map<String,dynamic>> fetchCredit(String movieId) async {

    final url = Uri.parse('https://api.themoviedb.org/3/movie/$movieId/credits?language=en-US');

    final response = await httpClient.get(url,headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Something happened');
    }
  }

}
