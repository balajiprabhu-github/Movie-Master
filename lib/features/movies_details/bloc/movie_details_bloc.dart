import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'movie_details_event.dart';
part 'movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {

  MovieDetailsBloc() : super(MovieDetailsInitial()) {
    on<MovieDetailsOnCrewLoadEvent>(movieDetailsOnCrewLoadEvent);
    on<MovieDetailsOnBackPressedEvent>(movieDetailsOnBackPressEvent);
  }

  FutureOr<void> movieDetailsOnCrewLoadEvent(
      MovieDetailsOnCrewLoadEvent event, Emitter<MovieDetailsState> emit) {
  }

  FutureOr<void> movieDetailsOnBackPressEvent(MovieDetailsOnBackPressedEvent event, Emitter<MovieDetailsState> emit) {
    emit(MovieDetailsOnBackPressState());
  }
}
