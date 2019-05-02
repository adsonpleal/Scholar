import 'package:app_tcc/modules/base/module.dart';
import 'package:app_tcc/modules/restaurants/restaurants_repository.dart';
import 'package:kiwi/kiwi.dart';

part 'restaurants_module.g.dart';

abstract class RestaurantsInjector {
  @Register.singleton(RestaurantsRepository)
  void configure();
}

class RestaurantsModule extends Module {
  @override
  void setup() {
    var injector = _$RestaurantsInjector();
    injector.configure();
  }
}
