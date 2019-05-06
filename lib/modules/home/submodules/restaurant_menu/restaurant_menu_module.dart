import 'package:app_tcc/modules/base/module.dart';
import 'package:app_tcc/modules/home/submodules/restaurant_menu/restaurant_menu_bloc.dart';
import 'package:kiwi/kiwi.dart';


part 'restaurant_menu_module.g.dart';

abstract class RestaurantMenuInjector {
  @Register.factory(RestaurantMenuBloc)
  void configure();
}

class RestaurantMenuModule extends Module {
  @override
  void setup() {
    var injector = _$RestaurantMenuInjector();
    injector.configure();
  }
}
