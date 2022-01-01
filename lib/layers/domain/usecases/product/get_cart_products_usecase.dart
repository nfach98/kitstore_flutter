import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:store_app/core/error/failures.dart';
import 'package:store_app/core/usecase/usecase.dart';
import 'package:store_app/layers/domain/entities/product.dart';
import 'package:store_app/layers/domain/repositories/product_repository.dart';

class GetCartProductsUsecase extends UseCase<List<Product>, NoParams> {
  final ProductRepository repository;

  GetCartProductsUsecase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) async {
    return await repository.getCartProducts();
  }
}