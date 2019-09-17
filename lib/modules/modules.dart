import 'agenda/agenda_module.dart';
import 'auth/auth_module.dart';
import 'base/module.dart';
import 'event_details/event_details_module.dart';
import 'home/home_module.dart';
import 'login/login_signup_module.dart';
import 'main/main_module.dart';
import 'new_event/new_event_module.dart';
import 'profile/profile_module.dart';
import 'restaurants/restaurants_module.dart';
import 'splash/splash_module.dart';
import 'ufsc/connect_ufsc_module.dart';
import 'user_data/user_data_module.dart';

void setupModules() {
  <Module>[
    AuthModule(),
    UserDataModule(),
    SplashModule(),
    LoginSignUpModule(),
    ProfileModule(),
    ConnectUfscModule(),
    HomeModule(),
    AgendaModule(),
    NewEventModule(),
    RestaurantsModule(),
    MainModule(),
    EventDetailsModule(),
  ].forEach((module) => module.setup());
}
