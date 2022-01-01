import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:store_app/core/error/failures.dart';
import 'package:store_app/core/usecase/usecase.dart';
import 'package:store_app/layers/domain/repositories/product_repository.dart';

class DeleteCartUsecase extends UseCase<int, DeleteCartParams> {
  final ProductRepository repository;

  DeleteCartUsecase(this.repository);

  @override
  Future<Either<Failure, int>> call(DeleteCartParams params) async {
    return await repository.deleteCart(
      id: params.id,
      idBrand: params.idBrand
    );
  }
}

class DeleteCartParams extends Equatable {
  final String id;
  final String idBrand;

  const DeleteCartParams({
    this.id,
    this.idBrand
  });

  @override
  List<Object> get props => [
    id,
    idBrand,
  ];
}