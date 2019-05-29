import 'dart:async';

import 'package:app_tcc/models/settings.dart';
import 'package:app_tcc/modules/user_data/user_data_repository.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_code_generator/annotations.dart';

import 'main_state.dart';

part 'main_bloc.g.dart';

@GenerateBloc(MainState)
class MainBloc extends _$Bloc {
  final UserDataRepository _userData = inject();
  StreamSubscription<Settings> _settingsSubscription;

  @override
  MainState get initialState => MainState.initial();

  MainBloc() {
    _trackUserData();
  }

  Stream<MainState> _mapSettingsChangedToState(Settings settings) async* {
    yield currentState.rebuild(
      (b) => b..settings.replace(settings),
    );
  }

  @override
  dispose() {
    _settingsSubscription?.cancel();
    super.dispose();
  }

  void _trackUserData() {
    _settingsSubscription = _userData.settingsStream?.listen(
      dispatchSettingsChangedEvent,
    );
  }
}
