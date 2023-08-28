part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

abstract class HomeActionState {}

class HomeInitial extends HomeState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class HomeOnLoadedSuccessState extends HomeState with EquatableMixin {
  final List<MovieSectionData> movieSectionList;
  HomeOnLoadedSuccessState({required this.movieSectionList});

  @override
  List<Object?> get props => [movieSectionList];
}

class HomeOnErrorState extends HomeState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class HomeOnMovieCardItemClickState extends HomeState with EquatableMixin {
  MovieDetailsData movieDetailsData;
  HomeOnMovieCardItemClickState({required this.movieDetailsData});

  @override
  List<Object?> get props => [];
}