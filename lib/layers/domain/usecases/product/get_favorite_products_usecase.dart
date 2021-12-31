import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:store_app/core/error/failures.dart';
import 'package:store_app/core/usecase/usecase.dart';
import 'package:store_app/layers/domain/entities/product.dart';
import 'package:store_app/layers/domain/repositories/product_repository.dart';

class GetFavoriteProductsUsecase extends UseCase<List<Product>, GetFavoriteProductsParams> {
  final ProductRepository repository;

  GetFavoriteProductsUsecase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(GetFavoriteProductsParams params) async {
    return await repository.getFavoriteProducts(
      page: params.page,
      limit: params.limit
    );
  }
}

class GetFavoriteProductsParams extends Equatable {
  final int page;
  final int limit;

  const GetFavoriteProductsParams({
    this.page,
    this.limit,
  });

  @override
  List<Object> get props => [
    page,
    limit,
  ];
}