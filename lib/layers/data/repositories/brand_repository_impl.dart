import 'package:dartz/dartz.dart';
import 'package:store_app/core/error/exceptions.dart';
import 'package:store_app/core/error/failures.dart';
import 'package:store_app/layers/data/sources/local/brand_local_data_source.dart';
import 'package:store_app/layers/domain/entities/brand.dart';
import 'package:store_app/layers/domain/repositories/brand_repository.dart';

typedef _ListBrandLoader = Future<List<Brand>> Function();

class BrandRepositoryImpl extends BrandRepository {
  final BrandLocalDataSource localDataSource;

  BrandRepositoryImpl({
    this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Brand>>> getBrands() async {
    return await _getBrands(() async {
      return localDataSource.getBrands();
    });
  }


  Future<Either<Failure, List<Brand>>> _getBrands(_ListBrandLoader getBrands) async {
    try {
      final local = await getBrands();
      return Right(local);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}