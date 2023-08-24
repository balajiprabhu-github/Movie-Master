part of 'splash_bloc.dart';

@immutable
abstract class SplashState {}

abstract class SplashActionState extends SplashState {}

class SplashInitial extends SplashState {}

class SplashAnimationEndState extends SplashState {}