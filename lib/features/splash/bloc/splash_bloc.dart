import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {

  SplashBloc() : super(SplashInitial()) {
    on<SplashAnimationStartEvent>(_splashAnimationStartEvent);
  }

  FutureOr<void> _splashAnimationStartEvent(SplashAnimationStartEvent event, Emitter<SplashState> emit) async {
    emit(SplashInitial());
    await Future.delayed(const Duration(seconds: 2));
    emit(SplashAnimationEndState());
  }
}
