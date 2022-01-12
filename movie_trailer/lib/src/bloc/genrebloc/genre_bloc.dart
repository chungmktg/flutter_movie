import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_trailer/src/bloc/moviebloc/movie_bloc_event.dart';
import 'package:movie_trailer/src/model/genre.dart';
import 'package:movie_trailer/src/model/movie.dart';
import 'package:movie_trailer/src/service/api_service.dart';

import 'dart:developer';

import 'genre_bloc_event.dart';
import 'genre_bloc_state.dart';

class GenreBloc extends Bloc<GenreEvent, GenreState> {
  GenreBloc() : super(GenreLoading());

  @override
  Stream<GenreState> mapEventToState(GenreEvent event) async* {
    if (event is GenreEventStarted) {
      yield* _mapGenreEventStateToState();
    }
  }

  Stream<GenreState> _mapGenreEventStateToState() async* {
    final service = ApiService();
    yield GenreLoading();
    try {
      List<Genre> genreList;
     genreList = await service.getGenreList();

      yield GenreLoaded(genreList);
    } on Exception catch (e) {
      yield GenreError();
    }
  }
}