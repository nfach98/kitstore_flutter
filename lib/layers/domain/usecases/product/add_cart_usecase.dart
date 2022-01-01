import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:store_app/core/error/failures.dart';
import 'package:store_app/core/usecase/usecase.dart';
import 'package:store_app/layers/domain/repositories/product_repository.dart';

class AddCartUsecase extends UseCase<int, AddCartParams> {
  final ProductRepository repository;

  AddCartUsecase(this.repository);

  @override
  Future<Either<Failure, int>> call(AddCartParams params) async {
    return await repository.addCart(
      id: params.id,
      qty: params.qty
    );
  }
}

class AddCartParams extends Equatable {
  final String id;
  final int qty;

  const AddCartParams({
    this.id,
    this.qty,
  });

  @override
  List<Object> get props => [
    id,
    qty,
  ];
}