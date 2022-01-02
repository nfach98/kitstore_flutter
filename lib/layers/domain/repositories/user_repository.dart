import 'package:dartz/dartz.dart';
import 'package:store_app/core/error/failures.dart';
import 'package:store_app/layers/domain/entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> login({String email, String password});

  Future<Either<Failure, int>> register({String name, String email, String password});

  Future<Either<Failure, bool>> logout();

  Future<Either<Failure, User>> getLoggedInUser();

  Future<Either<Failure, int>> updateUser({String name, String email, String password, String avatar});
}