import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:store_app/core/error/failures.dart';
import 'package:store_app/layers/domain/entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts({String search, String sort, String brands, RangeValues price, int page, int limit});

  Future<Either<Failure, List<Product>>> getFavoriteProducts({int page, int limit});

  Future<Either<Failure, int>> addFavorite({String id});

  Future<Either<Failure, int>> deleteFavorite({String id});

  // Future<Either<Failure, int>> addPeople({required String name, required String height, required String mass, required String hairColor, required String skinColor, required String birthYear, required String gender});
  //
  // Future<Either<Failure, int>> updatePeople({required String id, required String name, required String height, required String mass, required String hairColor, required String skinColor, required String birthYear, required String gender});
  //
  // Future<Either<Failure, int>> deletePeople({required String id});
  //
  // Future<Either<Failure, int>> isFavorite({required String id});
  //
  // Future<Either<Failure, List<People>>> getFavorites();
}