import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:store_app/core/error/failures.dart';
import 'package:store_app/core/usecase/usecase.dart';
import 'package:store_app/layers/domain/repositories/user_repository.dart';

class RegisterUsecase extends UseCase<int, RegisterParams> {
  final UserRepository repository;

  RegisterUsecase(this.repository);

  @override
  Future<Either<Failure, int>> call(RegisterParams params) async {
    return await repository.register(
      name: params.name,
      email: params.email,
      password: params.password
    );
  }
}

class RegisterParams extends Equatable {
  final String name;
  final String email;
  final String password;

  const RegisterParams({
    @required this.name,
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [
    name,
    email,
    password,
  ];
}