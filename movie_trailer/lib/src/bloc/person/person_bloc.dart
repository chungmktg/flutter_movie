import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_trailer/src/bloc/person/person_bloc_event.dart';
import 'package:movie_trailer/src/model/person.dart';
import 'package:movie_trailer/src/service/api_service.dart';

import 'person_bloc_state.dart';

class PersonBloc extends Bloc<PersonEvent, PersonState> {
  PersonBloc() : super(PersonLoading());

  @override
  Stream<PersonState> mapEventToState(PersonEvent event) async* {
    if (event is PersonEventStarted) {
      yield* _mapPersonEventStateToState();
    }
  }

  Stream<PersonState> _mapPersonEventStateToState() async* {
    final service = ApiService();
    yield PersonLoading();
    try {
      List<Person> personList;
      personList = await service.getTrendingPerson();

      yield PersonLoaded(personList);
    } on Exception catch (e) {
      yield PersonError();
    }
  }
}
