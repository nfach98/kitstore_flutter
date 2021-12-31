import 'package:store_app/core/sqlite/sqlite_helper.dart';
import 'package:store_app/layers/data/models/brand_model.dart';

abstract class BrandLocalDataSource {
  Future<List<BrandModel>> getBrands();
}

class BrandLocalDataSourceImpl implements BrandLocalDataSource {
  SQLiteHelper helper = SQLiteHelper();

  @override
  Future<List<BrandModel>> getBrands() async {
    var dbClient = await helper.db;

    List<BrandModel> brands = [];
    List<Map<String, dynamic>> map = await dbClient.query('brands');
    if (map.isNotEmpty) {
      map.forEach((element) {
        brands.add(BrandModel.fromJson(element));
      });
    }

    return brands;
  }
}