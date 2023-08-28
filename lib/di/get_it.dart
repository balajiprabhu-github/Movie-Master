import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:movies/features/home/bloc/home_bloc.dart';
import 'package:movies/features/movies_details/bloc/movie_details_bloc.dart';
import 'package:movies/features/splash/bloc/splash_bloc.dart';
import 'package:movies/repository/network/api_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerFactory(() => http.Client());
  locator.registerSingleton<ApiService>(ApiService(locator<http.Client>()));
  locator.registerFactory<SplashBloc>(() => SplashBloc());
  locator.registerFactory<HomeBloc>(() => HomeBloc());
  locator.registerFactory<MovieDetailsBloc>(() => MovieDetailsBloc());
}