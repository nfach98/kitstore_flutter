import 'package:flutter/material.dart';
import 'package:darq/darq.dart';
import 'package:store_app/core/usecase/usecase.dart';
import 'package:store_app/layers/domain/entities/brand.dart';
import 'package:store_app/layers/domain/entities/product.dart';
import 'package:store_app/layers/domain/usecases/product/delete_cart_usecase.dart';
import 'package:store_app/layers/domain/usecases/product/get_cart_products_usecase.dart';
import 'package:store_app/layers/domain/usecases/product/update_cart_usecase.dart';

class CartNotifier with ChangeNotifier {
  final GetCartProductsUsecase _cartProductsUsecase;
  final UpdateCartUsecase _updateCartUsecase;
  final DeleteCartUsecase _deleteCartUsecase;

  CartNotifier({
    @required GetCartProductsUsecase cartProductsUsecase,
    @required UpdateCartUsecase updateCartUsecase,
    @required DeleteCartUsecase deleteCartUsecase,
  }) : _cartProductsUsecase = cartProductsUsecase,
        _updateCartUsecase = updateCartUsecase,
        _deleteCartUsecase = deleteCartUsecase;

  List<Brand> listBrand;
  List<Product> listProduct;
  List<int> listSelected;
  bool isLoadingProduct = true;

  int grandTotal = 0;

  Future<void> getProducts() async {
    isLoadingProduct = true;
    notifyListeners();

    final result = await _cartProductsUsecase(NoParams());

    result.fold(
      (error) { },
      (success) {
        listProduct = success;

        listBrand = listProduct.map((e) => e.brand).toList();
        listBrand = listBrand.distinct((brand) => brand.id).toList();

        listSelected = listProduct.where((e) => e.isSelected == 1).map((e) => e.id).toList();

        setGrandTotal();
      }
    );

    isLoadingProduct = false;
    notifyListeners();
  }

  Future<int> updateCart({String id, String idBrand, bool isSelected, int qty}) async {
    int status;

    final result = await _updateCartUsecase(UpdateCartParams(
      id: id,
      idBrand: idBrand,
      isSelected: isSelected,
      qty: qty
    ));

    result.fold(
      (error) { },
      (success) {
        status = success;
        if (id != null) {
          List<Product> list = List.from(listProduct);
          list.forEach((element) {
            if (element.id == int.parse(id)) {
              element.isSelected = isSelected ? 1 : 0;
              element.qty = qty;
            }
          });
          listProduct = list;
        }
        else if (idBrand != null){
          List<Product> list = List.from(listProduct);
          list.forEach((element) {
            if (element.idBrand == int.parse(idBrand)) {
              element.isSelected = isSelected ? 1 : 0;
            }
          });
          listProduct = list;
        }
        else {
          List<Product> list = List.from(listProduct);
          list.forEach((element) {
            element.isSelected = isSelected ? 1 : 0;
          });
          listProduct = list;
        }
        setGrandTotal();
      }
    );

    notifyListeners();
    return status;
  }

  Future<int> deleteCart({String id, String idBrand}) async {
    int status;

    final result = await _deleteCartUsecase(DeleteCartParams(
      id: id,
      idBrand: idBrand
    ));

    result.fold(
      (error) { },
      (success) {
        status = success;
        List<Product> list = List.from(listProduct);
        if (idBrand != null) {
          list.removeWhere((element) => element.idBrand == int.parse(idBrand));
        }
        else {
          list.removeWhere((element) => element.id == int.parse(id));
        }

        listProduct = list;

        listBrand = listProduct.map((e) => e.brand).toList();
        listBrand = listBrand.distinct((brand) => brand.id).toList();

        listSelected = listProduct.where((e) => e.isSelected == 1).map((e) => e.id).toList();

        setGrandTotal();
      }
    );

    notifyListeners();
    return status;
  }

  addSelected(int value) {
    List<int> list = List.from(listSelected);
    list.add(value);
    listSelected = list;
    setGrandTotal();

    notifyListeners();
  }

  removeSelected(int value) {
    List<int> list = List.from(listSelected);
    list.remove(value);
    listSelected = list;
    setGrandTotal();

    notifyListeners();
  }

  addSelectedBrand(int value) async {
    List<Product> products = List.from(listProduct);
    products = products.where((element) => element.idBrand == value).toList();

    List<int> list = List.from(listSelected);
    list.addAll(products.map((e) => e.id).toList());
    listSelected = list;
    setGrandTotal();

    notifyListeners();
  }

  removeSelectedBrand(int value) async {
    List<Product> products = List.from(listProduct);
    products = products.where((element) => element.idBrand == value).toList();

    List<int> list = List.from(listSelected);
    list.removeWhere((element) => products.map((e) => e.id).toList().contains(element));
    listSelected = list;
    setGrandTotal();

    notifyListeners();
  }

  addAll() {
    List<int> list = List.from(listSelected);
    list.addAll(listProduct.map((e) => e.id).toList());
    listSelected = list;
    setGrandTotal();

    notifyListeners();
  }

  removeAll() {
    List<int> list = List.from(listSelected);
    list.clear();
    listSelected = list;
    setGrandTotal();

    notifyListeners();
  }

  setGrandTotal() {
    List<Product> products = listProduct.where((element) => listSelected.contains(element.id)).toList();
    if (products.isNotEmpty) {
      grandTotal = products.map((e) => e.price * e.qty).sum();
    }
    else {
      grandTotal = 0;
    }

    notifyListeners();
  }

  reset() {
    listBrand = null;
    listSelected = null;
    listProduct = null;
    isLoadingProduct = true;

    grandTotal = 0;

    notifyListeners();
  }
}