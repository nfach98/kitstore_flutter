import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:store_app/core/error/failures.dart';
import 'package:store_app/core/usecase/usecase.dart';
import 'package:store_app/layers/domain/entities/user.dart';
import 'package:store_app/layers/domain/repositories/user_repository.dart';

class GetLoggedInUserUsecase extends UseCase<User, NoParams> {
  final UserRepository repository;

  GetLoggedInUserUsecase(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await repository.getLoggedInUser();
  }
}