import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:store_app/core/error/failures.dart';
import 'package:store_app/layers/domain/entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts({String search, String sort, String brands, RangeValues price, int page, int limit});

  Future<Either<Failure, List<Product>>> getFavoriteProducts({int page, int limit});

  Future<Either<Failure, List<Product>>> getCartProducts();

  Future<Either<Failure, int>> addFavorite({String id});

  Future<Either<Failure, int>> deleteFavorite({String id});

  Future<Either<Failure, int>> addCart({String id, int qty});

  Future<Either<Failure, int>> updateCart({String id, String idBrand, bool isSelected, int qty});

  Future<Either<Failure, int>> deleteCart({String id, String idBrand});
}