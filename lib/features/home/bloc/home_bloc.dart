import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:movies/di/get_it.dart';
import 'package:movies/features/movies_details/data/movie_details_data.dart';
import 'package:movies/features/movies_details/data/movie_rating_data.dart';
import 'package:movies/repository/network/api_service.dart';

import '../../../repository/model/credits.dart';
import '../../../repository/model/trending_movies.dart';
import '../data/movie_section_data.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  final ApiService apiService = locator<ApiService>();

  HomeBloc() : super(HomeInitial()) {
    on<HomeOnLoadEvent>(_homeOnLoadEvent);
    on<HomeOnMovieCardItemClickEvent>(_homeOnMovieCardItemClickEvent);
  }

  FutureOr<void> _homeOnLoadEvent(HomeOnLoadEvent event, Emitter<HomeState> emit) async {
    emit(HomeInitial());
    try {
      var movieSectionsList = await apiService.fetchMovieSectionList();
      emit(HomeOnLoadedSuccessState(movieSectionList: movieSectionsList));
    } on Exception catch (_) {
      emit(HomeOnErrorState());
      print(_);
    }
  }

  FutureOr<void> _homeOnMovieCardItemClickEvent(HomeOnMovieCardItemClickEvent event, Emitter<HomeState> emit) async {

    var results  = event.results;
    var genreList = await apiService.fetchGenres();
    var genre = genreList.map((e) => e.toJson());
    var genreMap = _getGenreNamesByIds(genre, results.genreIds);
    var creditsResponse = await apiService.fetchCredit(results.id.toString());
    List<dynamic> castData = creditsResponse['cast'];
    List<dynamic> crewData = creditsResponse['crew'];
    var castList = castData.map((json) => Cast.fromJson(json)).toList();
    var crewList = crewData.map((json) => Crew.fromJson(json)).toList();
    var voteAverage = event.results.voteAverage ?? 0;
    emit(HomeOnMovieCardItemClickState(
        movieDetailsData: MovieDetailsData(
            results: results,
            castList: castList,
            directorName: _getTechnicianNameByJob(crewList,'Director').toString(),
            movieRatingData: MovieRatingData(
              progressColor: _movieRatingProgressColor(voteAverage),
              percentage: _movieRatingPercentage(voteAverage),
              percentageLabel: _movieRatingPercentageLabel(voteAverage)
            ),
            genresMap: genreMap
        )
    ));
  }

  Map<int, String> _getGenreNamesByIds(
      Iterable<Map<String, dynamic>> genresData, List<int>? genreIds) {
    Map<int, String> genreNames = {};

    if (genreIds == null) {
      return genreNames; // Return an empty map if genreIds is null.
    }

    for (int genreId in genreIds) {
      for (Map<String, dynamic> genre in genresData) {
        if (genre['id'] == genreId) {
          genreNames[genreId] = genre['name'];
          break;
        }
      }
    }

    return genreNames;
  }

  String? _getTechnicianNameByJob(List<Crew> crewList, String job) {
    return crewList.firstWhere(
          (crew) => crew.job == job,
    ).name ?? '';
  }

  Color _movieRatingProgressColor(num voteAverage) {
    final sealedVoteAverage = voteAverage.toInt();
    if (sealedVoteAverage >= 7) {
      return Colors.green;
    } else if (sealedVoteAverage < 7 && sealedVoteAverage > 5) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  double _movieRatingPercentage(num voteAverage) {
    return voteAverage / 10;
  }

  String _movieRatingPercentageLabel(num voteAverage) {
    int percentageValue = (voteAverage * 10).toInt();
    return '$percentageValue%';
  }
}
