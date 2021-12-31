import 'package:dartz/dartz.dart';
import 'package:store_app/core/error/failures.dart';
import 'package:store_app/core/usecase/usecase.dart';
import 'package:store_app/layers/domain/entities/brand.dart';
import 'package:store_app/layers/domain/repositories/brand_repository.dart';

class GetBrandsUsecase extends UseCase<List<Brand>, NoParams> {
  final BrandRepository repository;

  GetBrandsUsecase(this.repository);

  @override
  Future<Either<Failure, List<Brand>>> call(NoParams params) async {
    return await repository.getBrands();
  }
}