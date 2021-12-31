import 'package:equatable/equatable.dart';

class Brand extends Equatable {
  final int id;
  final String name;
  final String image;

  Brand({
    this.id,
    this.name,
    this.image
  });

  @override
  List<Object> get props => [
    id,
    name,
    image
  ];
}