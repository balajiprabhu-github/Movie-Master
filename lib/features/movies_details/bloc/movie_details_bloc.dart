import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'movie_details_event.dart';
part 'movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {

  MovieDetailsBloc() : super(MovieDetailsInitial()) {
    on<MovieDetailsOnCrewLoadEvent>(_movieDetailsOnCrewLoadEvent);
    on<MovieDetailsOnBackPressedEvent>(_movieDetailsOnBackPressEvent);
  }

  FutureOr<void> _movieDetailsOnCrewLoadEvent(
      MovieDetailsOnCrewLoadEvent event, Emitter<MovieDetailsState> emit) {
  }

  FutureOr<void> _movieDetailsOnBackPressEvent(MovieDetailsOnBackPressedEvent event, Emitter<MovieDetailsState> emit) {
    emit(MovieDetailsOnBackPressState());
  }
}
