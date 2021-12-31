import 'package:dartz/dartz.dart';
import 'package:store_app/core/error/failures.dart';
import 'package:store_app/layers/domain/entities/brand.dart';

abstract class BrandRepository {
  Future<Either<Failure, List<Brand>>> getBrands();
}