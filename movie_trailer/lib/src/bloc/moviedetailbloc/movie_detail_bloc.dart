import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_trailer/src/service/api_service.dart';

import 'movie_detail_bloc_event.dart';
import 'movie_detail_bloc_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  MovieDetailBloc() : super(MovieDetailLoading());

  @override
  Stream<MovieDetailState> mapEventToState(MovieDetailEvent event) async* {
    if (event is MovieDetailEventStated) {
      yield* _mapMovieEventStartedToState(event.id);
    }
  }

  Stream<MovieDetailState> _mapMovieEventStartedToState(int id) async* {
    final apiRepository = ApiService();
    yield MovieDetailLoading();
    try {

      final movieDetail = await apiRepository.getMovieDetail(id);

      yield MovieDetailLoaded(movieDetail);
    } on Exception catch (e) {
      yield MovieDetailError();
    }
  }
}