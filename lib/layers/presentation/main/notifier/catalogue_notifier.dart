import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:store_app/core/usecase/usecase.dart';
import 'package:store_app/layers/domain/entities/brand.dart';
import 'package:store_app/layers/domain/entities/product.dart';
import 'package:store_app/layers/domain/usecases/brand/get_brands_usecase.dart';
import 'package:store_app/layers/domain/usecases/product/add_favorite_usecase.dart';
import 'package:store_app/layers/domain/usecases/product/delete_favorite_usecase.dart';
import 'package:store_app/layers/domain/usecases/product/get_products_usecase.dart';

class CatalogueNotifier with ChangeNotifier {
  final GetProductsUsecase _productsUsecase;
  final GetBrandsUsecase _brandsUsecase;
  final AddFavoriteUsecase _addFavoriteUsecase;
  final DeleteFavoriteUsecase _deleteFavoriteUsecase;

  CatalogueNotifier({
    @required GetProductsUsecase productsUsecase,
    @required GetBrandsUsecase brandsUsecase,
    @required AddFavoriteUsecase addFavoriteUsecase,
    @required DeleteFavoriteUsecase deleteFavoriteUsecase,
  }) : _productsUsecase = productsUsecase,
        _brandsUsecase = brandsUsecase,
        _addFavoriteUsecase = addFavoriteUsecase,
        _deleteFavoriteUsecase = deleteFavoriteUsecase;

  int modeView = 0;

  List<Product> listProduct = [];
  bool isLoadingProduct = true;
  bool isKeepLoadingProduct = true;
  int page = 1;
  int limit = 12;
  String search;

  List<Brand> listBrand;
  bool isLoadingBrand = true;
  List<Brand> listSelectedBrand = [];

  RangeValues rangePrice;

  List<String> listSort = [
    "p.price DESC",
    "p.price ASC",
  ];
  String sort;

  Future<void> getProducts({String search}) async {
    if (isKeepLoadingProduct) {
      isLoadingProduct = true;
      notifyListeners();

      final result = await _productsUsecase(GetProductsParams(
        search: search,
        sort: sort,
        brands: listSelectedBrand.isEmpty ? null : listSelectedBrand.map((e) => e.id).toList().join(","),
        price: rangePrice,
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

  Future<void> getBrands() async {
    isLoadingBrand = true;
    notifyListeners();

    final result = await _brandsUsecase(NoParams());

    result.fold(
      (error) { },
      (success) {
        listBrand = success;
      }
    );

    isLoadingBrand = false;
    notifyListeners();
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

  updateProduct({int id, int isFavorite}) {
    List<Product> list = List.from(listProduct);
    list.forEach((element) {
      if (element.id == id) {
        element.isFavorite = isFavorite;
      }
    });
    listProduct = list;
    notifyListeners();
  }

  setModeView(int value) {
    modeView = value;
    notifyListeners();
  }

  // addSelectedBrand(int value) {
  //   List<int> list = List.from(listSelectedBrand);
  //   list.add(value);
  //   listSelectedBrand = list;
  //   notifyListeners();
  // }
  //
  // removeSelectedBrand(int value) {
  //   List<int> list = List.from(listSelectedBrand);
  //   list.remove(value);
  //   listSelectedBrand = list;
  //   notifyListeners();
  // }

  setSelectedBrand(List<Brand> value) {
    listSelectedBrand = value;
    notifyListeners();
  }

  setSort(String value) {
    sort = value;
    notifyListeners();
  }

  setPriceRange(RangeValues value) {
    rangePrice = value;
    notifyListeners();
  }

  resetList() {
    listProduct = [];
    isLoadingProduct = true;
    isKeepLoadingProduct = true;
    page = 1;

    notifyListeners();
  }

  resetFilter() {
    listSelectedBrand = [];
    rangePrice = null;
    sort = null;

    notifyListeners();
  }

  reset() {
    modeView = 0;

    listProduct = [];
    isLoadingProduct = true;
    isKeepLoadingProduct = true;
    page = 1;
    search = null;

    listBrand = null;
    isLoadingBrand = true;
    listSelectedBrand = [];

    rangePrice = null;

    notifyListeners();
  }
}