import 'dart:async';

import 'package:app_tcc/models/schedule.dart';
import 'package:app_tcc/models/single_event.dart';
import 'package:app_tcc/modules/user_data/user_data_repository.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_builder/annotations.dart';
import 'package:rxdart/streams.dart';

import 'home_state.dart';

part 'home_bloc.g.dart';

@BuildBloc(HomeState)
class HomeBloc extends _$Bloc {
  final UserDataRepository _userData = inject();
  StreamSubscription<bool> _loadingSubscription;

  HomeBloc() {
    _initStreams();
  }

  @override
  HomeState get initialState => HomeState.initial();

  Stream<HomeState> _mapShowInfoToState() async* {
    yield currentState.rebuild((b) => b..showInfoAlert = SingleEvent(true));
  }

  Stream<HomeState> _mapLoadingChangedToState(bool isLoading) async* {
    yield currentState.rebuild((b) => b..isLoading = isLoading);
  }

  void _initStreams() {
    _loadingSubscription = ZipStream(
      [
        _userData.subjectsStream,
        _userData.schedulesStream,
        _userData.restaurantStream,
      ],
      (values) => false,
    ).listen(dispatchLoadingChangedEvent);
  }

  @override
  void dispose() {
    _loadingSubscription?.cancel();
    super.dispose();
  }
}
