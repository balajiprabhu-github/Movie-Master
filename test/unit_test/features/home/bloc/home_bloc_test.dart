import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:movies/features/home/bloc/home_bloc.dart';
import 'package:movies/repository/network/api_service.dart';


void main() {

  group('HomeBloc', () {
    late HomeBloc homeBloc;
    late ApiService apiService;

    setUp(() async {
      GetIt.I.reset();
      final getIt = GetIt.instance;
      getIt.registerFactory(() => http.Client());
      getIt.registerSingleton<ApiService>(ApiService(getIt<http.Client>()));
      getIt.registerFactory<HomeBloc>(() => HomeBloc());
      homeBloc = getIt<HomeBloc>();
      apiService = getIt<ApiService>();
    });

    tearDown(() {
      homeBloc.close();
    });

    test('initial state is HomeBloc', () {
      expect(homeBloc,equals(HomeBloc()));
    });

    blocTest<HomeBloc,HomeState>(
      'emits [HomeInitial] when HomeOnLoadEvent is added',
      build: () => homeBloc,
      act: (bloc) {
        bloc.add(HomeOnLoadEvent());
      },
      expect: () => [
        HomeInitial()
      ]
    );

  });

}