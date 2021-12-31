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

  // Future<int> addPeople({required String name, required String height, required String mass, required String hairColor, required String skinColor, required String birthYear, required String gender});
  //
  // Future<int> updatePeople({required String id, required String name, required String height, required String mass, required String hairColor, required String skinColor, required String birthYear, required String gender});
  //
  // Future<int> deletePeople({required String id});
  //
  // Future<int> isFavorite({required String id});
  //
  Future<int> addFavorite({String id});

  Future<int> deleteFavorite({String id});
  //
  // Future<List<PeopleModel>> getFavorites();
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

  // @override
  // Future<int> isFavorite({required String id}) async {
  //   var dbClient = await helper.db;
  //   var prefs = await SharedPreferences.getInstance();
  //   String? stringValue = prefs.getString('user');
  //
  //   Map<String, dynamic> user = {};
  //   if (stringValue != null) user = json.decode(stringValue);
  //   print(user["id"]);
  //
  //   List<Map<String, dynamic>> maps = await dbClient!.query('favorites',
  //       where: "id_people = ? AND id_user = ?",
  //       whereArgs: [id, user["id"]]
  //   );
  //   return maps.isNotEmpty ? 1 : 0;
  // }
  //
  // @override
  // Future<int> addPeople({required String name, required String height, required String mass, required String hairColor, required String skinColor, required String birthYear, required String gender}) async {
  //   var dbClient = await helper.db;
  //   var map = {
  //     'name' : name,
  //     'height' : height,
  //     'mass' : mass,
  //     'hair_color' : hairColor,
  //     'skin_color' : skinColor,
  //     'birth_year' : birthYear,
  //     'gender' : gender
  //   };
  //
  //   return await dbClient!.insert('peoples', map);
  // }
  //
  // @override
  // Future<int> updatePeople({required String id, required String name, required String height, required String mass, required String hairColor, required String skinColor, required String birthYear, required String gender}) async {
  //   var dbClient = await helper.db;
  //   var map = {
  //     'name' : name,
  //     'height' : height,
  //     'mass' : mass,
  //     'hair_color' : hairColor,
  //     'skin_color' : skinColor,
  //     'birth_year' : birthYear,
  //     'gender' : gender
  //   };
  //
  //   return await dbClient!.update(
  //     'peoples',
  //     map,
  //     where: 'id = ?',
  //     whereArgs: [id],
  //   );
  // }
  //
  // @override
  // Future<int> deletePeople({required String id}) async {
  //   var dbClient = await helper.db;
  //   return await dbClient!.delete(
  //     'peoples',
  //     where: 'id = ?',
  //     whereArgs: [id],
  //   );
  // }
  //
  // @override
  // Future<int> addFavorite({required String id}) async {
  //   var dbClient = await helper.db;
  //   var prefs = await SharedPreferences.getInstance();
  //   String? stringValue = prefs.getString('user');
  //
  //   Map<String, dynamic> user = {};
  //   if (stringValue != null) user = json.decode(stringValue);
  //   print(user["id"]);
  //
  //   var map = {
  //     'id_people' : id,
  //     'id_user' : user["id"]
  //   };
  //
  //   return await dbClient!.insert('favorites', map);
  // }
  //
  // @override
  // Future<int> deleteFavorite({required String id}) async {
  //   var dbClient = await helper.db;
  //   var prefs = await SharedPreferences.getInstance();
  //   String? stringValue = prefs.getString('user');
  //
  //   Map<String, dynamic> user = {};
  //   if (stringValue != null) user = json.decode(stringValue);
  //   print(user["id"]);
  //
  //   return await dbClient!.delete(
  //     'favorites',
  //     where: 'id_people = ? AND id_user = ?',
  //     whereArgs: [id, user["id"]],
  //   );
  // }
  //
  // @override
  // Future<List<PeopleModel>> getFavorites() async {
  //   var dbClient = await helper.db;
  //   var prefs = await SharedPreferences.getInstance();
  //   String? stringValue = prefs.getString('user');
  //
  //   Map<String, dynamic> user = {};
  //   if (stringValue != null) user = json.decode(stringValue);
  //   print(user["id"]);
  //
  //   List<Map<String, dynamic>> maps = await dbClient!.rawQuery("""
  //     SELECT p.* from favorites f
  //     INNER JOIN peoples p ON p.id = f.id
  //     WHERE f.id_user = ${user["id"]}
  //   """);
  //
  //   List<PeopleModel> peoples = [];
  //   for (Map<String, dynamic> map in maps) {
  //     peoples.add(PeopleModel.fromJson(map));
  //   }
  //
  //   return peoples;
  // }
}