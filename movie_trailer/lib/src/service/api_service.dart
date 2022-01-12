

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:movie_trailer/src/model/cast_list.dart';
import 'package:movie_trailer/src/model/genre.dart';
import 'package:movie_trailer/src/model/movie.dart';
import 'package:movie_trailer/src/model/movie_detail.dart';
import 'package:movie_trailer/src/model/movie_image.dart';
import 'package:movie_trailer/src/model/person.dart';

class ApiService {
  final Dio _dio =  Dio();
  String baseUrl = "https://api.themoviedb.org/3";
  final String apiKey = '1fe1679f868c70c107ec8c3b4031fd79';

  Future<List<Movie>> getNowPlayingMovie () async {
    // ignore: avoid_print
    try {
        final response = await _dio.get('$baseUrl/movie/now_playing?api_key=$apiKey');
        var movies = response.data['results'] as List;
        List<Movie> movieList = movies.map((e) => Movie.fromJson(e)).toList();
        return movieList;
    } catch (e) {
      throw Exception('error: $e');
    }
  }

    Future<List<Genre>> getGenreList() async {
    try {
      final response = await _dio.get('$baseUrl/genre/movie/list?api_key=$apiKey');
      var genres = response.data['genres'] as List;
      List<Genre> genreList = genres.map((g) => Genre.fromJson(g)).toList();
      return genreList;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

  Future<List<Movie>> getMovieByGenre(int movieId) async {
    try {
      final url = '$baseUrl/discover/movie?with_genres=$movieId&api_key=$apiKey';
      final response = await _dio.get(url);
      var movies = response.data['results'] as List;
      List<Movie> movieList = movies.map((m) => Movie.fromJson(m)).toList();
      return movieList;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

   Future<List<Person>> getTrendingPerson() async {
    try {
      final response = await _dio.get('$baseUrl/trending/person/week?api_key=$apiKey');
      var persons = response.data['results'] as List;
      List<Person> personList = persons.map((p) => Person.fromJson(p)).toList();
      return personList;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

    Future<MovieDetail> getMovieDetail(int movieId) async {
    try {

      final response = await _dio.get('$baseUrl/movie/$movieId?api_key=$apiKey');
      MovieDetail movieDetail = MovieDetail.fromJson(response.data);


      movieDetail.trailerId = await getYoutubeId(movieId);

      movieDetail.movieImage = await getMovieImage(movieId);

      movieDetail.castList = await getCastList(movieId);
      
      return movieDetail;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

    Future<String> getYoutubeId(int id) async {
    try {
      final response = await _dio.get('$baseUrl/movie/$id/videos?api_key=$apiKey');
      var youtubeId = response.data['results'][0]['key'];
      return youtubeId;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

  Future<MovieImage> getMovieImage(int movieId) async {
    try {
      final response = await _dio.get('$baseUrl/movie/$movieId/images?api_key=$apiKey');
      return MovieImage.fromJson(response.data);
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

  Future<List<Cast>> getCastList(int movieId) async {
    try {
      final response =
          await _dio.get('$baseUrl/movie/$movieId/credits?api_key=$apiKey');
      var list = response.data['cast'] as List;
      List<Cast> castList = list
          .map((c) => Cast(
              name: c['name'],
              profilePath: c['profile_path'],
              character: c['character']))
          .toList();
      return castList;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }
}