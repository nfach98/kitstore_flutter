import 'package:dartz/dartz.dart';
import 'package:store_app/core/error/exceptions.dart';
import 'package:store_app/core/error/failures.dart';
import 'package:store_app/layers/data/sources/local/user_local_data_source.dart';
import 'package:store_app/layers/domain/entities/user.dart';
import 'package:store_app/layers/domain/repositories/user_repository.dart';

typedef _IntLoader = Future<int> Function();
typedef _UserLoader = Future<User> Function();
typedef _BoolLoader = Future<bool> Function();

class UserRepositoryImpl extends UserRepository {
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl({
    this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> login({String email, String password}) async {
    return await _getUser(() {
      return localDataSource.login(
        email: email,
        password: password
      );
    });
  }

  @override
  Future<Either<Failure, int>> register({String name, String email, String password}) async {
    return await _getInt(() {
      return localDataSource.register(
        name: name,
        email: email,
        password: password
      );
    });
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    return await _getBool(() {
      return localDataSource.logout();
    });
  }

  @override
  Future<Either<Failure, User>> getLoggedInUser() async {
    return await _getUser(() {
      return localDataSource.getLoggedInUser();
    });
  }

  @override
  Future<Either<Failure, int>> updateUser({String name, String email, String password, String avatar}) async {
    return await _getInt(() {
      return localDataSource.updateUser(
        name: name,
        email: email,
        password: password,
        avatar: avatar
      );
    });
  }


  Future<Either<Failure, int>> _getInt(_IntLoader getInt) async {
    try {
      final remote = await getInt();
      return Right(remote);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  Future<Either<Failure, User>> _getUser(_UserLoader getUser) async {
    try {
      final remote = await getUser();
      return Right(remote);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  Future<Either<Failure, bool>> _getBool(_BoolLoader getBool) async {
    try {
      final remote = await getBool();
      return Right(remote);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}