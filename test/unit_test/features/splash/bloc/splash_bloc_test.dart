import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movies/features/splash/bloc/splash_bloc.dart';

void main() {

  group('SplashBloc', () {

    late SplashBloc splashBloc;

    setUp(() {
      splashBloc = SplashBloc();
    });

    tearDown(() {
      splashBloc.close();
    });

    group('_splashAnimationStartEvent', () {

      test('initial state is SplashInitial', () {
        expect(splashBloc.state, equals(SplashInitial()));
      });

      blocTest<SplashBloc, SplashState>(
        '_homeOnLoadEvent emit HomeInitial state',
        build: () => SplashBloc(),
        act: (bloc) async {
          bloc.add(SplashAnimationStartEvent());
          await Future.delayed(const Duration(seconds: 2));
        },
        expect: () => <SplashState>[
          SplashInitial(),
          SplashAnimationEndState()
        ],
      );

    });

  });

}