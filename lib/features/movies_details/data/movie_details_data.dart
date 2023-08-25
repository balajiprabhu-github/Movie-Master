import 'package:movies/features/movies_details/data/movie_rating_data.dart';

import '../../../repository/model/credits.dart';
import '../../../repository/model/trending_movies.dart';

class MovieDetailsData {

  final Results results;
  final List<Cast> castList;
  final String directorName;
  final MovieRatingData movieRatingData;
  final Map<int, String> genresMap;

  MovieDetailsData({
    required this.results,
    required this.castList,
    required this.directorName,
    required this.movieRatingData,
    required this.genresMap,
  });
}