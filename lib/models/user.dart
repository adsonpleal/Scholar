import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(nullable: false)
class User extends Equatable {
  final String firstName;
  final String lastName;

  User(this.firstName, this.lastName) : super([firstName, lastName]);
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  String get fullName => "$firstName $lastName";
}
