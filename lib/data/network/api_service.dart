import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies/data/model/credits.dart';
import '../constants.dart';
import '../model/genres.dart';
import '../model/trending_movies.dart';

final headers = {
  'Authorization':
  'Bearer $bearerToken',
  'Content-Type': 'application/json',
};

class ApiService {

  Future<List<Results>> fetchMoviesByUrl(String url) async {

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Results.fromJson(movie)).toList();
    } else {
      throw Exception('Something happened');
    }
  }

  Future<List<Genre>> fetchGenres() async {

    final response = await http.get(Uri.parse(genreUrl), headers: headers);

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['genres'] as List;
      return decodedData.map((genre) => Genre.fromJson(genre)).toList();
    } else {
      throw Exception('Something happened');
    }
  }


  Future<Map<String,dynamic>> fetchCredit(String movieId) async {

    final url = Uri.parse('https://api.themoviedb.org/3/movie/$movieId/credits?language=en-US');

    final response = await http.get(url,headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Something happened');
    }
  }

}
