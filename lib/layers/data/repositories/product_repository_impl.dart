import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:store_app/core/error/exceptions.dart';
import 'package:store_app/core/error/failures.dart';
import 'package:store_app/layers/data/sources/local/product_local_data_source.dart';
import 'package:store_app/layers/domain/entities/product.dart';
import 'package:store_app/layers/domain/repositories/product_repository.dart';

typedef _ListProductLoader = Future<List<Product>> Function();
typedef _IntLoader = Future<int> Function();

class ProductRepositoryImpl extends ProductRepository {
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({
    this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Product>>> getProducts({String search, String sort, String brands, RangeValues price, int page, int limit}) async {
    return await _getProducts(() async {
      return localDataSource.getProducts(
        search: search,
        sort: sort,
        price: price,
        brands: brands,
        page: page,
        limit: limit
      );
    });
  }

  @override
  Future<Either<Failure, List<Product>>> getFavoriteProducts({int page, int limit}) async {
    return await _getProducts(() async {
      return localDataSource.getFavoriteProducts(
        page: page,
        limit: limit
      );
    });
  }

  @override
  Future<Either<Failure, List<Product>>> getCartProducts() async {
    return await _getProducts(() async {
      return localDataSource.getCartProducts();
    });
  }

  @override
  Future<Either<Failure, int>> addFavorite({String id}) async {
    return await _getInt(() async {
      return localDataSource.addFavorite(id: id);
    });
  }

  @override
  Future<Either<Failure, int>> deleteFavorite({String id}) async {
    return await _getInt(() async {
      return localDataSource.deleteFavorite(id: id);
    });
  }

  @override
  Future<Either<Failure, int>> addCart({String id, int qty}) async {
    return await _getInt(() async {
      return localDataSource.addCart(
        id: id,
        qty: qty
      );
    });
  }

  @override
  Future<Either<Failure, int>> updateCart({String id, bool isSelected, int qty}) async {
    return await _getInt(() async {
      return localDataSource.updateCart(
        id: id,
        isSelected: isSelected,
        qty: qty
      );
    });
  }

  @override
  Future<Either<Failure, int>> deleteCart({String id, String idBrand}) async {
    return await _getInt(() async {
      return localDataSource.deleteCart(
        id: id,
        idBrand: idBrand
      );
    });
  }


  Future<Either<Failure, List<Product>>> _getProducts(_ListProductLoader getProducts) async {
    try {
      final local = await getProducts();
      return Right(local);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  Future<Either<Failure, int>> _getInt(_IntLoader getInt) async {
    try {
      final local = await getInt();
      return Right(local);
    } on ServerException {
      return Left(CacheFailure());
    }
  }
}