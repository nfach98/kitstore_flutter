
import 'package:flutter/material.dart';
import 'package:store_app/core/usecase/usecase.dart';
import 'package:store_app/layers/domain/entities/product.dart';
import 'package:store_app/layers/domain/usecases/product/add_cart_usecase.dart';
import 'package:store_app/layers/domain/usecases/product/add_favorite_usecase.dart';
import 'package:store_app/layers/domain/usecases/product/delete_favorite_usecase.dart';
import 'package:store_app/layers/domain/usecases/product/get_cart_products_usecase.dart';

class DetailNotifier with ChangeNotifier {
  final GetCartProductsUsecase _cartProductsUsecase;
  final AddCartUsecase _addCartUsecase;
  final AddFavoriteUsecase _addFavoriteUsecase;
  final DeleteFavoriteUsecase _deleteFavoriteUsecase;

  DetailNotifier({
    @required GetCartProductsUsecase cartProductsUsecase,
    @required AddCartUsecase addCartUsecase,
    @required AddFavoriteUsecase addFavoriteUsecase,
    @required DeleteFavoriteUsecase deleteFavoriteUsecase,
  }) : _cartProductsUsecase = cartProductsUsecase,
        _addCartUsecase = addCartUsecase,
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

      final result = await _cartProductsUsecase(NoParams());

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

  Future<int> addCart({String id, int qty}) async {
    int status;

    final result = await _addCartUsecase(AddCartParams(
      id: id,
      qty: qty
    ));

    result.fold(
      (error) { },
      (success) {
        status = success;
      }
    );

    notifyListeners();
    return status;
  }

  Future<int> addFavorite({String id}) async {
    int status;

    final result = await _addFavoriteUsecase(AddFavoriteParams(id: id));

    result.fold(
      (error) { },
      (success) {
        status = success;
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