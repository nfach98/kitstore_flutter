import 'package:equatable/equatable.dart';

import 'brand.dart';

class Product extends Equatable implements Comparable {
  final int id;
  final int idBrand;
  final String name;
  final String image;
  final int price;
  final int qty;
  int isFavorite;
  final Brand brand;

  Product({
    this.id,
    this.idBrand,
    this.name,
    this.image,
    this.price,
    this.qty,
    this.isFavorite,
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
    brand
  ];

  @override
  int compareTo(other) {
    if (this.price == null || other == null) {
      return null;
    }

    if (this.price < other.price) {
      return 1;
    }

    if (this.price > other.price) {
      return -1;
    }

    if (this.price == other.price) {
      return 0;
    }

    return null;
  }
}