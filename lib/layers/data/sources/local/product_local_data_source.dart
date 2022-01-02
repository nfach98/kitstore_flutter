import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/core/sqlite/sqlite_helper.dart';
import 'package:store_app/layers/data/models/brand_model.dart';
import 'package:store_app/layers/data/models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getProducts({String search, String sort, String brands, RangeValues price, int page, int limit});

  Future<List<ProductModel>> getFavoriteProducts({int page, int limit});

  Future<List<ProductModel>> getCartProducts();

  Future<int> addFavorite({String id});

  Future<int> deleteFavorite({String id});

  Future<int> addCart({String id, int qty});

  Future<int> updateCart({String id, String idBrand, bool isSelected, int qty});

  Future<int> deleteCart({String id, String idBrand});
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  SQLiteHelper helper = SQLiteHelper();

  @override
  Future<List<ProductModel>> getProducts({String search, String sort, String brands, RangeValues price, int page, int limit}) async {
    var dbClient = await helper.db;
    var prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('user');

    Map<String, dynamic> user = {};
    if (stringValue != null) user = json.decode(stringValue);

    String where = "";
    String orderBy = "";

    if (search != null) {
      where = where.isEmpty
        ? """WHERE p.name LIKE '%$search%' OR b.name LIKE '%$search%'"""
        : """$where AND p.name LIKE '%$search%' OR b.name LIKE '%$search%'""";
    }
    if (brands != null) {
      where = where.isEmpty
        ? """WHERE p.id_brand IN ($brands)"""
        : """$where AND p.id_brand IN ($brands)""";
    }
    if (price != null) {
      where = where.isEmpty
        ? """WHERE p.price >= ${price.start} AND p.price <= ${price.end}"""
        : """$where AND p.price >= ${price.start} AND p.price <= ${price.end}""";
    }
    if (sort != null) {
      orderBy = orderBy.isEmpty
        ? """ORDER BY $sort"""
        : """$orderBy, $sort""";
    }

    List<Map<String, dynamic>> maps = await dbClient.rawQuery("""
      SELECT p.*, (CASE WHEN cp.qty IS NULL THEN 0 ELSE cp.qty END) AS qty, (CASE WHEN fp.is_favorite IS NULL THEN 0 ELSE fp.is_favorite END) AS is_favorite FROM products p
      LEFT JOIN favorite_products fp ON p.id = fp.id_product AND fp.id_user = ${user["id"]}
      LEFT JOIN cart_products cp ON p.id = cp.id_product AND cp.id_user = ${user["id"]}
      INNER JOIN brands b ON b.id = p.id_brand
      $where
      $orderBy
      LIMIT $limit OFFSET ${(page - 1) * limit}
    """);

    List<ProductModel> products = [];
    for (Map<String, dynamic> map in maps) {
      var prod = ProductModel.fromJson(map);
      List<Map<String, dynamic>> mapBrand = await dbClient.query('brands',
        where: "id = ?",
        whereArgs: [prod.idBrand]
      );
      if (mapBrand.isNotEmpty) {
        prod.brand = BrandModel.fromJson(mapBrand[0]);
      }

      products.add(prod);
    }

    return products;
  }

  @override
  Future<List<ProductModel>> getFavoriteProducts({int page, int limit}) async {
    var dbClient = await helper.db;
    var prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('user');

    Map<String, dynamic> user = {};
    if (stringValue != null) {
      user = json.decode(stringValue) as Map<String, dynamic>;
    }

    List<Map<String, dynamic>> maps = await dbClient.rawQuery("""
      SELECT p.*, (CASE WHEN cp.qty IS NULL THEN 0 ELSE cp.qty END) AS qty, fp.is_favorite FROM favorite_products fp
      INNER JOIN products p ON fp.id_product = p.id
      LEFT JOIN cart_products cp ON p.id = cp.id_product AND cp.id_user = ${user["id"]}
      WHERE fp.id_user = ${user["id"]}
      ORDER BY fp.id DESC
      LIMIT $limit OFFSET ${(page - 1) * limit}
    """);

    List<ProductModel> products = [];
    for (Map<String, dynamic> map in maps) {
      var prod = ProductModel.fromJson(map);
      List<Map<String, dynamic>> mapBrand = await dbClient.query('brands',
        where: "id = ?",
        whereArgs: [prod.idBrand]
      );
      if (mapBrand.isNotEmpty) {
        prod.brand = BrandModel.fromJson(mapBrand[0]);
      }

      products.add(prod);
    }

    return products;
  }

  @override
  Future<List<ProductModel>> getCartProducts() async {
    var dbClient = await helper.db;
    var prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('user');

    Map<String, dynamic> user = {};
    if (stringValue != null) {
      user = json.decode(stringValue) as Map<String, dynamic>;
    }

    List<Map<String, dynamic>> maps = await dbClient.rawQuery("""
      SELECT p.id, p.id_brand, p.name, p.image, p.price, cp.qty, cp.is_selected FROM cart_products cp
      INNER JOIN products p ON p.id = cp.id_product
      WHERE cp.id_user = ${user["id"]}
      ORDER BY cp.id DESC
    """);

    List<ProductModel> products = [];
    for (Map<String, dynamic> map in maps) {
      var prod = ProductModel.fromJson(map);
      List<Map<String, dynamic>> mapBrand = await dbClient.query('brands',
        where: "id = ?",
        whereArgs: [prod.idBrand]
      );
      if (mapBrand.isNotEmpty) {
        prod.brand = BrandModel.fromJson(mapBrand.first);
      }

      products.add(prod);
    }

    return products;
  }

  @override
  Future<int> addFavorite({String id}) async {
    var dbClient = await helper.db;
    var prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('user');

    Map<String, dynamic> user = {};
    if (stringValue != null) {
      user = json.decode(stringValue) as Map<String, dynamic>;
    }

    var map = {
      'id_product' : id,
      'id_user' : user["id"],
      'is_favorite' : 1
    };

    return await dbClient.insert('favorite_products', map);
  }

  @override
  Future<int> deleteFavorite({String id}) async {
    var dbClient = await helper.db;
    var prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('user');

    Map<String, dynamic> user = {};
    if (stringValue != null) {
      user = json.decode(stringValue) as Map<String, dynamic>;
    }

    return await dbClient.delete(
      'favorite_products',
      where: 'id_product = ? AND id_user = ?',
      whereArgs: [id, user["id"]],
    );
  }

  @override
  Future<int> addCart({String id, int qty}) async {
    var dbClient = await helper.db;
    var prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('user');

    Map<String, dynamic> user = {};
    if (stringValue != null) {
      user = json.decode(stringValue) as Map<String, dynamic>;
    }

    List<Map<String, dynamic>> maps = await dbClient.query('cart_products',
      where: "id_product = ? AND id_user = ?",
      whereArgs: [id, user["id"]]
    );

    if (maps.isEmpty) {
      var map = {
        'id_product' : id,
        'id_user' : user["id"],
        'is_selected': 0,
        'qty' : qty
      };

      return await dbClient.insert('cart_products', map);
    }

    else {
      var map = {
        'qty' : qty,
        'is_selected': maps.first["is_selected"]
      };

      return await dbClient.update(
        'cart_products',
        map,
        where: "id_product = ? AND id_user = ?",
        whereArgs: [id, user["id"]]
      );
    }
  }

  @override
  Future<int> updateCart({String id, String idBrand, bool isSelected, int qty}) async {
    var dbClient = await helper.db;
    var prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('user');

    Map<String, dynamic> user = {};
    if (stringValue != null) {
      user = json.decode(stringValue) as Map<String, dynamic>;
    }

    var map = {
      'is_selected' : isSelected ? 1 : 0
    };

    if (id != null) {
      map['qty'] = qty;
      return await dbClient.update(
        'cart_products',
        map,
        where: "id_product = ? AND id_user = ?",
        whereArgs: [id, user["id"]]
      );
    }
    else if (idBrand != null) {
      List<Map<String, dynamic>> maps = await dbClient.rawQuery("""
      UPDATE cart_products
      SET is_selected = ${isSelected ? 1 : 0}
      WHERE id_product IN (
        SELECT p.id FROM cart_products cp
        INNER JOIN products p ON p.id = cp.id_product
        WHERE cp.id_user = ${user["id"]} AND p.id_brand = $idBrand
      )
    """);

      return maps.length;
    }

    else {
      return await dbClient.update(
        'cart_products',
        map,
        where: "id_user = ?",
        whereArgs: [user["id"]]
      );
    }
  }

  @override
  Future<int> deleteCart({String id, String idBrand}) async {
    var dbClient = await helper.db;
    var prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('user');

    Map<String, dynamic> user = {};
    if (stringValue != null) {
      user = json.decode(stringValue) as Map<String, dynamic>;
    }

    if (idBrand == null) {
      return await dbClient.delete(
        'cart_products',
        where: 'id_product = ? AND id_user = ?',
        whereArgs: [id, user["id"]],
      );
    }
    else {
      List<Map<String, dynamic>> maps = await dbClient.rawQuery("""
      DELETE FROM cart_products
      WHERE id_product IN (
        SELECT p.id FROM cart_products cp
        INNER JOIN products p ON p.id = cp.id_product
        WHERE cp.id_user = ${user["id"]} AND p.id_brand = $idBrand
      )
    """);

      return maps.length;
    }
  }
}