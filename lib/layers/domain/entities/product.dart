import 'package:equatable/equatable.dart';

import 'brand.dart';

class Product extends Equatable {
  final int id;
  final int idBrand;
  final String name;
  final String image;
  final int price;
  int qty;
  int isFavorite;
  int isSelected;
  final Brand brand;

  Product({
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

  @override
  List<Object> get props => [
    id,
    idBrand,
    name,
    image,
    price,
    qty,
    isFavorite,
    isSelected,
    brand
  ];
}