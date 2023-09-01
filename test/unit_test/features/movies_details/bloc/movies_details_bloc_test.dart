import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:movies/features/movies_details/bloc/movie_details_bloc.dart';

void main() {
  group('MovieDetailsBloc', () {
    late MovieDetailsBloc movieDetailsBloc;

    setUp(() {
      movieDetailsBloc = MovieDetailsBloc();
    });

    tearDown(() {
      movieDetailsBloc.close();
    });

    test('initial state is MovieDetailsInitial', () {
      expect(movieDetailsBloc.state, equals(MovieDetailsInitial()));
    });

    blocTest<MovieDetailsBloc, MovieDetailsState>(
      'emits [MovieDetailsOnBackPressState] when MovieDetailsOnBackPressedEvent is added',
      build: () => movieDetailsBloc,
      act: (bloc) async {
        bloc.add(MovieDetailsOnBackPressedEvent());
      },
      expect: () => [MovieDetailsOnBackPressState()],
    );
  });
}
