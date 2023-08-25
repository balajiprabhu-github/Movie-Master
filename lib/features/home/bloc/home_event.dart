part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

abstract class HomeActionEvent extends HomeEvent {}

class HomeOnLoadEvent extends HomeEvent {}

class HomeOnErrorEvent extends HomeEvent {}

class HomeOnMovieCardItemClickEvent extends HomeActionEvent {
  int itemIndex;
  HomeOnMovieCardItemClickEvent({required this.itemIndex});
}