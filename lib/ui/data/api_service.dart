import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies/ui/data/model/trending_movies.dart';

Future<List<Results>> fetchTrendingMovies() async {
  final headers = {
    'Authorization':
    'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmMzc4MTZhMDYzYWU4NzhiYmYyZDA0ODFjODI4NjNjYSIsInN1YiI6IjY0ZGExNjBhYmYzMWYyMDFjZTZhMDVhYSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.fg1wWJKM18EgjYulWEDyM_EPlyEIWFctMaTP8zOrxO0',
    'Content-Type': 'application/json',
  };

  final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/trending/movie/day?language=en-US'),
      headers: headers);

  if (response.statusCode == 200) {
    final decodedData = json.decode(response.body)['results'] as List;
    return decodedData.map((movie) => Results.fromJson(movie)).toList();
  } else {
    throw Exception('Something happened');
  }
}
