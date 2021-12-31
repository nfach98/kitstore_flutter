import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:store_app/core/error/failures.dart';
import 'package:store_app/core/usecase/usecase.dart';
import 'package:store_app/layers/domain/entities/product.dart';
import 'package:store_app/layers/domain/repositories/product_repository.dart';

class GetProductsUsecase extends UseCase<List<Product>, GetProductsParams> {
  final ProductRepository repository;

  GetProductsUsecase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(GetProductsParams params) async {
    return await repository.getProducts(
      search: params.search,
      sort: params.sort,
      brands: params.brands,
      price: params.price,
      page: params.page,
      limit: params.limit
    );
  }
}

class GetProductsParams extends Equatable {
  final String search;
  final String sort;
  final String brands;
  final RangeValues price;
  final int page;
  final int limit;

  const GetProductsParams({
    this.search,
    this.sort,
    this.brands,
    this.price,
    this.page,
    this.limit,
  });

  @override
  List<Object> get props => [
    search,
    sort,
    brands,
    price,
    page,
    limit,
  ];
}