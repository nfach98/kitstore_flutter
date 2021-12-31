import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final String password;
  final String avatar;

  User({
    this.id,
    this.name,
    this.email,
    this.password,
    this.avatar,
  });

  @override
  List<Object> get props => [
    id,
    name,
    email,
    password,
    avatar,
  ];
}