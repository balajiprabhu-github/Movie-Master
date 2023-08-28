import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:movies/features/home/data/movie_section_data.dart';
import 'package:movies/repository/Constants.dart';
import 'package:movies/repository/model/genres.dart';
import 'package:movies/repository/model/trending_movies.dart';
import 'package:movies/repository/network/api_service.dart';
import '../mocks/mock_response_credits.dart';
import '../mocks/mock_response_genre_list.dart';
import '../mocks/mock_response_movie_list.dart';

@GenerateMocks([http.Client])
void main() {

  late ApiService apiService;

  group('ApiService Tests', () {

    group('fetchMoviesByUrl', () {
      test('fetchMoviesByUrl returns a list of movie results', () async {

        final mockClient = MockClient((request) async {
          return Response(jsonEncode(mockResponseMovieList), 200,headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          });
        });

        apiService = ApiService(mockClient);

        final movies = await apiService.fetchMoviesByUrl(trendingUrl);

        expect(movies, isA<List<Results>>());
        expect(movies.length, 2);
        expect(movies[0].title, 'Elemental');
        expect(movies[1].title, 'Heart of Stone');
      });

      test('throws an exception if the fetchMoviesByUrl completes with an error', () {

        final mockClient = MockClient((request) async {
          return Response('Internal Server Error', 500);
        });

        apiService = ApiService(mockClient);

        final movies = apiService.fetchMoviesByUrl(trendingUrl);

        expect(movies, throwsException);
      });
    });

    group('fetchMovieSectionList', () {

      test('fetchMovieSectionList return list of movie section if it completes with success', () async {

        final mockClient = MockClient((request) async {
          return Response(jsonEncode(mockResponseMovieList), 200,headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          });
        });

        apiService = ApiService(mockClient);

        final movieSectionList = await apiService.fetchMovieSectionList();

        expect(movieSectionList, isA<List<MovieSectionData>>());
      });

      test('throws an exception if the fetchMovieSectionList completes with an error', () {

        final mockClient = MockClient((request) async {
          return Response('Internal Server Error', 500);
        });

        apiService = ApiService(mockClient);

        final movieSectionList = apiService.fetchMovieSectionList();

        expect(movieSectionList, throwsException);
      });

    });

    group('fetchGenres', () {

      test('fetchGenres return list of genre if it completes with success', () async {

        final mockClient = MockClient((request) async {
          return Response(jsonEncode(mockResponseGenreList), 200,headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          });
        });

        apiService = ApiService(mockClient);

        final genreList = await apiService.fetchGenres();

        expect(genreList, isA<List<Genre>>());
      });

      test('throws an exception if the fetchGenres completes with an error', () {

        final mockClient = MockClient((request) async {
          return Response('Internal Server Error', 500);
        });

        apiService = ApiService(mockClient);

        final genreList = apiService.fetchGenres();

        expect(genreList, throwsException);
      });

    });

    group('fetchCredit', () {

      test('fetchCredit return Credits if it completes with success', () async {

        final mockClient = MockClient((request) async {
          return Response(jsonEncode(mockResponseCredits), 200,headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          });
        });

        apiService = ApiService(mockClient);

        final credits = await apiService.fetchCredit('movieId');

        expect(credits, isA<Map<String, dynamic>>());
      });

      test('throws an exception if the fetchCredit completes with an error', () {

        final mockClient = MockClient((request) async {
          return Response('Internal Server Error', 500);
        });

        apiService = ApiService(mockClient);

        final genreList = apiService.fetchGenres();

        expect(genreList, throwsException);
      });

    });

  });
}
