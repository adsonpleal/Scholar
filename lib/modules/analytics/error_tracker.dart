import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class ErrorTracker {
  void initUser(FirebaseUser user) {
    Crashlytics.instance.setUserEmail(user.email);
    Crashlytics.instance.setUserIdentifier(user.uid);
  }

  void track(error, stacktrace) {
    Crashlytics.instance.recordError(error, stacktrace);
  }
}
