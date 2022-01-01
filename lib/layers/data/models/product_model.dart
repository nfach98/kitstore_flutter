import 'package:store_app/layers/data/models/brand_model.dart';
import 'package:store_app/layers/domain/entities/product.dart';

class ProductModel extends Product {
  final int id;
  final int idBrand;
  final String name;
  final String image;
  final int price;
  int qty;
  int isFavorite;
  int isSelected;
  BrandModel brand;

  ProductModel({
    this.id,
    this.idBrand,
    this.name,
    this.image,
    this.price,
    this.qty,
    this.isFavorite,
    this.isSelected,
    this.brand,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    BrandModel brand;

    if (json['brand'] != null) {
      BrandModel.fromJson(json['brand']);
    }

    return ProductModel(
      id : json['id'],
      idBrand : json['id_brand'],
      name : json['name'],
      image : json['image'],
      price : json['price'],
      qty : json['qty'],
      isFavorite : json['is_favorite'],
      isSelected : json['is_selected'],
      brand : brand,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> brand;

    if (this.brand != null) {
      brand = this.brand.toJson();
    }

    return {
      'id' : id,
      'id_brand' : idBrand,
      'name' : name,
      'image' : image,
      'price' : price,
      'qty' : qty,
      'is_favorite' : isFavorite,
      'is_selected' : isSelected,
      'brand' : brand,
    };
  }
}