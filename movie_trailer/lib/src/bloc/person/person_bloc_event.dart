import 'package:equatable/equatable.dart';
import 'package:movie_trailer/src/model/person.dart';

abstract class PersonEvent extends Equatable {
  const PersonEvent();
}

class PersonEventStarted extends PersonEvent {
  @override
  List<Person?> get props => [];
}