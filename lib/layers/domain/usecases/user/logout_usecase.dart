import 'package:dartz/dartz.dart';
import 'package:store_app/core/error/failures.dart';
import 'package:store_app/core/usecase/usecase.dart';
import 'package:store_app/layers/domain/repositories/user_repository.dart';

class LogoutUsecase extends UseCase<bool, NoParams> {
  final UserRepository repository;

  LogoutUsecase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.logout();
  }
}