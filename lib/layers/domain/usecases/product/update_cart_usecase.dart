import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:store_app/core/error/failures.dart';
import 'package:store_app/core/usecase/usecase.dart';
import 'package:store_app/layers/domain/repositories/product_repository.dart';

class UpdateCartUsecase extends UseCase<int, UpdateCartParams> {
  final ProductRepository repository;

  UpdateCartUsecase(this.repository);

  @override
  Future<Either<Failure, int>> call(UpdateCartParams params) async {
    return await repository.updateCart(
      id: params.id,
      isSelected: params.isSelected,
      qty: params.qty
    );
  }
}

class UpdateCartParams extends Equatable {
  final String id;
  final bool isSelected;
  final int qty;

  const UpdateCartParams({
    this.id,
    this.isSelected,
    this.qty,
  });

  @override
  List<Object> get props => [
    id,
    isSelected,
    qty,
  ];
}