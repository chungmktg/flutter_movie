import 'package:equatable/equatable.dart';

abstract class GenreEvent extends Equatable {
  const GenreEvent();
}

class GenreEventStarted extends GenreEvent {
  @override
  List<Object?> get props => [];
}