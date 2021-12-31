import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:store_app/core/error/failures.dart';
import 'package:store_app/core/usecase/usecase.dart';
import 'package:store_app/layers/domain/repositories/product_repository.dart';

class AddFavoriteUsecase extends UseCase<int, AddFavoriteParams> {
  final ProductRepository repository;

  AddFavoriteUsecase(this.repository);

  @override
  Future<Either<Failure, int>> call(AddFavoriteParams params) async {
    return await repository.addFavorite(
      id: params.id,
    );
  }
}

class AddFavoriteParams extends Equatable {
  final String id;

  const AddFavoriteParams({
    this.id,
  });

  @override
  List<Object> get props => [
    id,
  ];
}