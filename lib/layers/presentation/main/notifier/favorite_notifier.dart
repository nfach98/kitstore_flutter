import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:store_app/layers/domain/entities/product.dart';
import 'package:store_app/layers/domain/usecases/product/add_favorite_usecase.dart';
import 'package:store_app/layers/domain/usecases/product/delete_favorite_usecase.dart';
import 'package:store_app/layers/domain/usecases/product/get_favorite_products_usecase.dart';

class FavoriteNotifier with ChangeNotifier {
  final GetFavoriteProductsUsecase _favoriteProductsUsecase;
  final AddFavoriteUsecase _addFavoriteUsecase;
  final DeleteFavoriteUsecase _deleteFavoriteUsecase;

  FavoriteNotifier({
    @required GetFavoriteProductsUsecase favoriteProductsUsecase,
    @required AddFavoriteUsecase addFavoriteUsecase,
    @required DeleteFavoriteUsecase deleteFavoriteUsecase,
  }) : _favoriteProductsUsecase = favoriteProductsUsecase,
        _addFavoriteUsecase = addFavoriteUsecase,
        _deleteFavoriteUsecase = deleteFavoriteUsecase;

  int modeView = 0;

  List<Product> listProduct = [];
  bool isLoadingProduct = true;
  bool isKeepLoadingProduct = true;
  int page = 1;
  int limit = 12;

  Future<void> getProducts({String search, String sort}) async {
    if (isKeepLoadingProduct) {
      isLoadingProduct = true;
      notifyListeners();

      final result = await _favoriteProductsUsecase(GetFavoriteProductsParams(
        page: page,
        limit: limit
      ));

      result.fold(
        (error) { },
        (success) {
          List<Product> list = List.from(listProduct);
          list.addAll(success);
          listProduct = list;
          if (success.length >= limit) {
            page++;
            isKeepLoadingProduct = true;
          }
          else {
            isKeepLoadingProduct = false;
          }
        }
      );
    }

    isLoadingProduct = false;
    notifyListeners();
  }

  Future<int> addFavorite({String id}) async {
    int status;

    final result = await _addFavoriteUsecase(AddFavoriteParams(id: id));

    result.fold(
      (error) { },
      (success) {
        status = success;
        List<Product> list = List.from(listProduct);
        list.forEach((element) {
          if (element.id == int.parse(id)) {
            element.isFavorite = 1;
          }
        });
        listProduct = list;
      }
    );

    notifyListeners();
    return status;
  }

  Future<int> deleteFavorite({String id}) async {
    int status;

    final result = await _deleteFavoriteUsecase(DeleteFavoriteParams(id: id));

    result.fold(
      (error) { },
      (success) {
        status = success;
        List<Product> list = List.from(listProduct);
        list.forEach((element) {
          if (element.id == int.parse(id)) {
            element.isFavorite = 0;
          }
        });
        listProduct = list;
      }
    );

    notifyListeners();
    return status;
  }

  reset() {
    modeView = 0;

    listProduct = [];
    isLoadingProduct = true;
    isKeepLoadingProduct = true;
    page = 1;

    notifyListeners();
  }
}