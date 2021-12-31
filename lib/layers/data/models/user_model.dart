import 'package:store_app/layers/domain/entities/user.dart';

class UserModel extends User {
  final int id;
  final String name;
  final String email;
  final String password;
  final String avatar;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.password,
    this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id : json['id'],
      name : json['name'],
      email : json['email'],
      password : json['password'],
      avatar : json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'name' : name,
      'email' : email,
      'password' : password,
      'avatar' : avatar,
    };
  }
}