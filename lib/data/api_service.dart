import 'dart:convert';

import 'package:http/http.dart' as http;
import 'constants.dart';
import 'model/trending_movies.dart';

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
}
