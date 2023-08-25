part of 'movie_details_bloc.dart';

@immutable
abstract class MovieDetailsEvent {}

class MovieDetailsOnCrewLoadEvent extends MovieDetailsEvent {}

class MovieDetailsOnBackPressedEvent extends MovieDetailsEvent {}