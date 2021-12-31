import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:store_app/core/error/failures.dart';
import 'package:store_app/core/usecase/usecase.dart';
import 'package:store_app/layers/domain/entities/user.dart';
import 'package:store_app/layers/domain/repositories/user_repository.dart';

class LoginUsecase extends UseCase<User, LoginParams> {
  final UserRepository repository;

  LoginUsecase(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.login(
      email: params.email,
      password: params.password
    );
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];
}