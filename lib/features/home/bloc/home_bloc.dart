import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movies/repository/network/api_service.dart';

import '../data/movie_section_data.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  HomeBloc() : super(HomeInitial()) {
    on<HomeOnLoadEvent>(homeOnLoadEvent);
    on<HomeOnErrorEvent>(homeOnErrorEvent);
    on<HomeOnMovieCardItemClickEvent>(homeOnMovieCardItemClickEvent);
  }

  FutureOr<void> homeOnLoadEvent(HomeOnLoadEvent event, Emitter<HomeState> emit) async {
    emit(HomeInitial());
    var movieSectionsList = await ApiService().fetchMovieSectionList();
    emit(HomeOnLoadedSuccessState(movieSectionList: movieSectionsList));
  }

  FutureOr<void> homeOnErrorEvent(HomeOnErrorEvent event, Emitter<HomeState> emit) {
    emit(HomeOnErrorState());
  }

  FutureOr<void> homeOnMovieCardItemClickEvent(HomeOnMovieCardItemClickEvent event, Emitter<HomeState> emit) {
    emit(HomeOnMovieCardItemClickState(itemIndex: event.itemIndex));
  }
}
