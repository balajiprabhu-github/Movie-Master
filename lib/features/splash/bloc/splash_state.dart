part of 'splash_bloc.dart';

@immutable
abstract class SplashState {}

abstract class SplashActionState extends SplashState {}

class SplashInitial extends SplashState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class SplashAnimationEndState extends SplashState with EquatableMixin {
  @override
  List<Object?> get props => [];
}