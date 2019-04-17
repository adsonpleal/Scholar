import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String email;

  User({this.email}) : super([email]);
}
