part of 'movie_details_bloc.dart';

@immutable
abstract class MovieDetailsState {}

class MovieDetailsInitial extends MovieDetailsState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class MovieDetailsOnBackPressState extends MovieDetailsState with EquatableMixin {
  @override
  List<Object?> get props => [];
}
