import 'package:get_it/get_it.dart';
import 'package:store_app/layers/data/repositories/brand_repository_impl.dart';
import 'package:store_app/layers/data/repositories/product_repository_impl.dart';
import 'package:store_app/layers/data/repositories/user_repository_impl.dart';
import 'package:store_app/layers/data/sources/local/brand_local_data_source.dart';
import 'package:store_app/layers/data/sources/local/product_local_data_source.dart';
import 'package:store_app/layers/data/sources/local/user_local_data_source.dart';
import 'package:store_app/layers/domain/repositories/brand_repository.dart';
import 'package:store_app/layers/domain/repositories/product_repository.dart';
import 'package:store_app/layers/domain/repositories/user_repository.dart';
import 'package:store_app/layers/domain/usecases/brand/get_brands_usecase.dart';
import 'package:store_app/layers/domain/usecases/product/add_cart_usecase.dart';
import 'package:store_app/layers/domain/usecases/product/add_favorite_usecase.dart';
import 'package:store_app/layers/domain/usecases/product/delete_cart_usecase.dart';
import 'package:store_app/layers/domain/usecases/product/delete_favorite_usecase.dart';
import 'package:store_app/layers/domain/usecases/product/get_cart_products_usecase.dart';
import 'package:store_app/layers/domain/usecases/product/get_favorite_products_usecase.dart';
import 'package:store_app/layers/domain/usecases/product/get_products_usecase.dart';
import 'package:store_app/layers/domain/usecases/product/update_cart_usecase.dart';
import 'package:store_app/layers/domain/usecases/user/get_logged_in_user_usecase.dart';
import 'package:store_app/layers/domain/usecases/user/login_usecase.dart';
import 'package:store_app/layers/domain/usecases/user/logout_usecase.dart';
import 'package:store_app/layers/domain/usecases/user/register_usecase.dart';
import 'package:store_app/layers/domain/usecases/user/update_user_usecase.dart';
import 'package:store_app/layers/presentation/account/notifier/about_notifier.dart';
import 'package:store_app/layers/presentation/account/notifier/edit_notifier.dart';
import 'package:store_app/layers/presentation/auth/notifier/auth_notifier.dart';
import 'package:store_app/layers/presentation/cart/notifier/cart_notifier.dart';
import 'package:store_app/layers/presentation/detail/notifier/detail_notifier.dart';
import 'package:store_app/layers/presentation/main/notifier/account_notifier.dart';
import 'package:store_app/layers/presentation/main/notifier/catalogue_notifier.dart';
import 'package:store_app/layers/presentation/main/notifier/favorite_notifier.dart';
import 'package:store_app/layers/presentation/main/notifier/main_notifier.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ===================== NOTIFIER ========================
  // Auth
  sl.registerFactory(() => AuthNotifier(
    loggedInUserUsecase: sl(),
    loginUsecase: sl(),
    logoutUsecase: sl(),
    registerUsecase: sl()
  ));

  // Main
  sl.registerFactory(() => MainNotifier());
  sl.registerFactory(() => CatalogueNotifier(
    productsUsecase: sl(),
    brandsUsecase: sl(),
    addFavoriteUsecase: sl(),
    deleteFavoriteUsecase: sl()
  ));
  sl.registerFactory(() => FavoriteNotifier(
    favoriteProductsUsecase: sl(),
    addFavoriteUsecase: sl(),
    deleteFavoriteUsecase: sl()
  ));
  sl.registerFactory(() => AccountNotifier(
    logoutUsecase: sl(),
    loggedInUserUsecase: sl()
  ));

  // Account
  sl.registerFactory(() => AboutNotifier());
  sl.registerFactory(() => EditNotifier(
    loggedInUserUsecase: sl(),
    updateUserUsecase: sl()
  ));

  // Detail
  sl.registerFactory(() => DetailNotifier(
    cartProductsUsecase: sl(),
    addCartUsecase: sl(),
    addFavoriteUsecase: sl(),
    deleteFavoriteUsecase: sl()
  ));

  // Cart
  sl.registerFactory(() => CartNotifier(
    cartProductsUsecase: sl(),
    updateCartUsecase: sl(),
    deleteCartUsecase: sl()
  ));

  // ===================== USECASES ========================
  // Brands
  sl.registerLazySingleton(() => GetBrandsUsecase(sl()));

  // Products
  sl.registerLazySingleton(() => AddFavoriteUsecase(sl()));
  sl.registerLazySingleton(() => AddCartUsecase(sl()));
  sl.registerLazySingleton(() => DeleteFavoriteUsecase(sl()));
  sl.registerLazySingleton(() => DeleteCartUsecase(sl()));
  sl.registerLazySingleton(() => GetProductsUsecase(sl()));
  sl.registerLazySingleton(() => GetCartProductsUsecase(sl()));
  sl.registerLazySingleton(() => GetFavoriteProductsUsecase(sl()));
  sl.registerLazySingleton(() => UpdateCartUsecase(sl()));

  // Users
  sl.registerLazySingleton(() => GetLoggedInUserUsecase(sl()));
  sl.registerLazySingleton(() => LoginUsecase(sl()));
  sl.registerLazySingleton(() => LogoutUsecase(sl()));
  sl.registerLazySingleton(() => RegisterUsecase(sl()));
  sl.registerLazySingleton(() => UpdateUserUsecase(sl()));

  // ===================== REPOSITORIES ========================
  // Brands
  sl.registerLazySingleton<BrandRepository>(
    () => BrandRepositoryImpl(localDataSource: sl()),
  );

  // Products
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(localDataSource: sl()),
  );

  // Users
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(localDataSource: sl()),
  );

  // ===================== SOURCES ========================
  // Brands
  sl.registerLazySingleton<BrandLocalDataSource>(
    () => BrandLocalDataSourceImpl(),
  );

  // Products
  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(),
  );

  // Users
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(),
  );
}