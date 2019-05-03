import 'package:bloc/bloc.dart';

import 'bloc_event.dart';

abstract class BaseBloc<E, S> extends Bloc<BlocEvent<E>, S> {
  @override
  Stream<S> mapEventToState(BlocEvent<E> event) async* {
    yield* mapToState(event.type, event.payload);
  }

  Stream<S> mapToState(E event, dynamic payload);

  dispatchEvent(E type, {dynamic payload}) {
    dispatch(BlocEvent<E>(type, payload));
  }
}
