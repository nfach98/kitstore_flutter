import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:store_app/layers/data/models/brand_model.dart';
import 'package:store_app/layers/data/models/product_model.dart';

class SQLiteHelper {
  static Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'store.db';
    var todoDatabase = openDatabase(path, version: 1, onCreate: _createDb);
    return todoDatabase;
  }

  void _createDb(Database db, int version) async {
    Batch batch = db.batch();
    batch.execute("""
      CREATE TABLE IF NOT EXISTS users(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        email TEXT UNIQUE,
        password TEXT,
        avatar TEXT
      )
    """);
    batch.execute("""
      CREATE TABLE IF NOT EXISTS brands(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        image TEXT
      )
    """);
    batch.execute("""
      CREATE TABLE IF NOT EXISTS products(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        id_brand INTEGER NOT NULL,
        name TEXT,
        image TEXT,
        price INTEGER,
        FOREIGN KEY (id_brand) REFERENCES brands (id) ON UPDATE CASCADE ON DELETE CASCADE
      )
    """);
    batch.execute("""
      CREATE TABLE IF NOT EXISTS favorite_products(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        id_product INTEGER NOT NULL,
        id_user INTEGER NOT NULL,
        is_favorite INTEGER NOT NULL,
        FOREIGN KEY (id_product) REFERENCES products (id) ON UPDATE CASCADE ON DELETE CASCADE,
        FOREIGN KEY (id_user) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE
      )
    """);
    batch.execute("""
      CREATE TABLE IF NOT EXISTS cart_products(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        id_product INTEGER NOT NULL,
        id_user INTEGER NOT NULL,
        is_selected INTEGER NOT NULL,
        qty INTEGER NOT NULL,
        FOREIGN KEY (id_product) REFERENCES products (id) ON UPDATE CASCADE ON DELETE CASCADE,
        FOREIGN KEY (id_user) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE
      )
    """);

    // Insert brands
    batch.insert('brands', BrandModel(
      name: "Adidas",
      image: "assets/images/brands/brand_1.png"
    ).toJson());
    batch.insert('brands', BrandModel(
      name: "Nike",
      image: "assets/images/brands/brand_2.png"
    ).toJson());
    batch.insert('brands', BrandModel(
      name: "Puma",
      image: "assets/images/brands/brand_3.png"
    ).toJson());
    batch.insert('brands', BrandModel(
      name: "New Balance",
      image: "assets/images/brands/brand_4.png"
    ).toJson());
    batch.insert('brands', BrandModel(
      name: "Umbro",
      image: "assets/images/brands/brand_5.png"
    ).toJson());
    batch.insert('brands', BrandModel(
      name: "Kappa",
      image: "assets/images/brands/brand_6.png"
    ).toJson());
    batch.insert('brands', BrandModel(
      name: "Macron",
      image: "assets/images/brands/brand_7.png"
    ).toJson());
    batch.insert('brands', BrandModel(
      name: "Hummel",
      image: "assets/images/brands/brand_8.png"
    ).toJson());

    // Insert products
    batch.insert('products', ProductModel(
      idBrand: 6,
      name: "Venezia 2021-22 Home Kit",
      image: "assets/images/products/product_1.jpg",
      price: 1500000,
    ).toJson());
    batch.insert('products', ProductModel(
      idBrand: 2,
      name: "Liverpool FC 2021-22 Home Kit",
      image: "assets/images/products/product_2.jpg",
      price: 780000,
    ).toJson());
    batch.insert('products', ProductModel(
      idBrand: 2,
      name: "Chelsea 2021-22 Home Kit",
      image: "assets/images/products/product_3.jpg",
      price: 1350000,
    ).toJson());
    batch.insert('products', ProductModel(
      idBrand: 1,
      name: "Manchester United 2021-22 Away Kit",
      image: "assets/images/products/product_4.jpg",
      price: 1300000,
    ).toJson());
    batch.insert('products', ProductModel(
      idBrand: 1,
      name: "Manchester United 2021-22 Home Kit",
      image: "assets/images/products/product_5.jpg",
      price: 1300000,
    ).toJson());
    batch.insert('products', ProductModel(
      idBrand: 1,
      name: "Manchester United 2021-22 Third Kit",
      image: "assets/images/products/product_6.jpg",
      price: 1300000,
    ).toJson());
    batch.insert('products', ProductModel(
      idBrand: 2,
      name: "Club América 2021 Third Jersey",
      image: "assets/images/products/product_7.png",
      price: 1250000,
    ).toJson());
    batch.insert('products', ProductModel(
      idBrand: 6,
      name: "Venezia 2021-22 Fourth Jersey",
      image: "assets/images/products/product_8.png",
      price: 1500000,
    ).toJson());
    batch.insert('products', ProductModel(
      idBrand: 8,
      name: "Denmark 2018 Home",
      image: "assets/images/products/product_9.jpg",
      price: 1200000,
    ).toJson());
    batch.insert('products', ProductModel(
      idBrand: 2,
      name: "Inter Milan 2021-22 Home",
      image: "assets/images/products/product_10.jpg",
      price: 1799000,
    ).toJson());
    batch.insert('products', ProductModel(
      idBrand: 1,
      name: "Juventus FC 2021-22 Home",
      image: "assets/images/products/product_11.jpg",
      price: 730000,
    ).toJson());
    batch.insert('products', ProductModel(
      idBrand: 1,
      name: "Germany Adidas EURO 2020 Away Jersey",
      image: "assets/images/products/product_12.png",
      price: 1200000,
    ).toJson());
    batch.insert('products', ProductModel(
      idBrand: 2,
      name: "Barcelona 2021-22 Third",
      image: "assets/images/products/product_13.jpg",
      price: 850000,
    ).toJson());
    batch.insert('products', ProductModel(
      idBrand: 5,
      name: "Iraq 2021-22 Third Kit",
      image: "assets/images/products/product_14.png",
      price: 1060000,
    ).toJson());
    batch.insert('products', ProductModel(
      idBrand: 3,
      name: "Manchester City 2021-22 Home Kit",
      image: "assets/images/products/product_15.jpg",
      price: 1000000,
    ).toJson());
    batch.insert('products', ProductModel(
      idBrand: 1,
      name: "Bayern München 2021-22 Home Kit",
      image: "assets/images/products/product_16.jpg",
      price: 975000,
    ).toJson());
    batch.insert('products', ProductModel(
      idBrand: 4,
      name: "FC Porto 21-22 Away Kit",
      image: "assets/images/products/product_17.png",
      price: 1260000,
    ).toJson());
    batch.insert('products', ProductModel(
      idBrand: 2,
      name: "Paris Saint-Germain Home Kit 2021-22",
      image: "assets/images/products/product_18.jpg",
      price: 1350000,
    ).toJson());
    batch.insert('products', ProductModel(
      idBrand: 1,
      name: "Ajax 21-22 Third Kit",
      image: "assets/images/products/product_19.png",
      price: 810000,
    ).toJson());
    batch.insert('products', ProductModel(
      idBrand: 2,
      name: "Atlético Madrid 2021-22 Home Kit",
      image: "assets/images/products/product_20.jpg",
      price: 1350000,
    ).toJson());
    batch.insert('products', ProductModel(
      idBrand: 7,
      name: "Sampdoria 2021-22 Home Kit",
      image: "assets/images/products/product_21.jpg",
      price: 1350000,
    ).toJson());
    batch.insert('products', ProductModel(
      idBrand: 2,
      name: "AIK Nike 2021 130th Anniversary Jersey",
      image: "assets/images/products/product_22.png",
      price: 1350000,
    ).toJson());
    batch.insert('products', ProductModel(
      idBrand: 3,
      name: "Borussia Dortmund 2021-22 Home Kit",
      image: "assets/images/products/product_23.jpg",
      price: 1350000,
    ).toJson());
    batch.insert('products', ProductModel(
      idBrand: 3,
      name: "Borussia Dortmund Puma 2020-2021 'Neongelb' Special Shirt",
      image: "assets/images/products/product_24.jpg",
      price: 1450000,
    ).toJson());
    batch.insert('products', ProductModel(
      idBrand: 1,
      name: "Japan 100th Anniversary Jersey",
      image: "assets/images/products/product_25.png",
      price: 1600000,
    ).toJson());
    batch.insert('products', ProductModel(
      idBrand: 1,
      name: "Real Madrid 2021-22 Away Kit",
      image: "assets/images/products/product_26.jpg",
      price: 770000,
    ).toJson());
    batch.insert('products', ProductModel(
      idBrand: 5,
      name: "Brentford 2021-22 Home",
      image: "assets/images/products/product_27.jpg",
      price: 950000,
    ).toJson());
    batch.insert('products', ProductModel(
      idBrand: 1,
      name: "Bayern München 21-22 Oktoberfest Shirt",
      image: "assets/images/products/product_28.jpg",
      price: 1150000,
    ).toJson());
    batch.insert('products', ProductModel(
      idBrand: 1,
      name: "Arsenal 2021-22 Home Kit",
      image: "assets/images/products/product_29.jpg",
      price: 1300000,
    ).toJson());
    batch.insert('products', ProductModel(
      idBrand: 3,
      name: "AC Milan 2021-22 Home Kit",
      image: "assets/images/products/product_30.jpg",
      price: 975000,
    ).toJson());
    batch.insert('products', ProductModel(
      idBrand: 2,
      name: "Inter Milan 2021-22 Third Kit",
      image: "assets/images/products/product_31.jpg",
      price: 1550000,
    ).toJson());

    await batch.commit();
  }
}