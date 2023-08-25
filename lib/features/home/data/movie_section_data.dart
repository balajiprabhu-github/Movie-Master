import 'package:movies/repository/model/trending_movies.dart';

class MovieSectionData {
  String? sectionTitle;
  List<Results> movieResultsList;

  MovieSectionData({required this.sectionTitle, required this.movieResultsList});
}