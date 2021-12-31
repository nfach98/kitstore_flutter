import 'package:store_app/layers/domain/entities/brand.dart';

class BrandModel extends Brand {
  final int id;
  final String name;
  final String image;

  BrandModel({
    this.id,
    this.name,
    this.image
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id : json['id'],
      name : json['name'],
      image : json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'name' : name,
      'image' : image,
    };
  }
}