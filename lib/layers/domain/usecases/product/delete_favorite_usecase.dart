import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:store_app/core/error/failures.dart';
import 'package:store_app/core/usecase/usecase.dart';
import 'package:store_app/layers/domain/repositories/product_repository.dart';

class DeleteFavoriteUsecase extends UseCase<int, DeleteFavoriteParams> {
  final ProductRepository repository;

  DeleteFavoriteUsecase(this.repository);

  @override
  Future<Either<Failure, int>> call(DeleteFavoriteParams params) async {
    return await repository.deleteFavorite(
      id: params.id,
    );
  }
}

class DeleteFavoriteParams extends Equatable {
  final String id;

  const DeleteFavoriteParams({
    this.id,
  });

  @override
  List<Object> get props => [
    id,
  ];
}