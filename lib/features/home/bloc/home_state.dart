part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

abstract class HomeActionState {}

class HomeInitial extends HomeState {}

class HomeOnLoadedSuccessState extends HomeState {
  final List<MovieSectionData> movieSectionList;
  HomeOnLoadedSuccessState({required this.movieSectionList});
}

class HomeOnErrorState extends HomeState {}

class HomeOnMovieCardItemClickState extends HomeState {
  int itemIndex;
  HomeOnMovieCardItemClickState({required this.itemIndex});
}