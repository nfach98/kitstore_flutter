import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:store_app/core/error/failures.dart';
import 'package:store_app/core/usecase/usecase.dart';
import 'package:store_app/layers/domain/repositories/user_repository.dart';

class UpdateUserUsecase extends UseCase<int, UpdateUserParams> {
  final UserRepository repository;

  UpdateUserUsecase(this.repository);

  @override
  Future<Either<Failure, int>> call(UpdateUserParams params) async {
    return await repository.updateUser(
      name: params.name,
      email: params.email,
      password: params.password,
      avatar: params.avatar,
    );
  }
}

class UpdateUserParams extends Equatable {
  final String name;
  final String email;
  final String password;
  final String avatar;

  const UpdateUserParams({
    this.name,
    this.email,
    this.password,
    this.avatar,
  });

  @override
  List<Object> get props => [
    name,
    email,
    password,
    avatar,
  ];
}