import 'package:equatable/equatable.dart';

abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();
}

class MovieDetailEventStated extends MovieDetailEvent {
  final int id;

  const MovieDetailEventStated(this.id);

  @override
  List<Object> get props => [];
}