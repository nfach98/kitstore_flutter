import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/core/config/constants.dart';
import 'package:store_app/layers/presentation/account/notifier/about_notifier.dart';
import 'package:store_app/layers/presentation/account/notifier/edit_notifier.dart';
import 'package:store_app/layers/presentation/account/notifier/security_notifier.dart';
import 'package:store_app/layers/presentation/auth/notifier/login_notifier.dart';
import 'package:store_app/core/di/injection_container.dart' as di;
import 'package:store_app/layers/presentation/auth/notifier/register_notifier.dart';
import 'package:store_app/layers/presentation/auth/page/splash_page.dart';
import 'package:store_app/layers/presentation/cart/notifier/cart_notifier.dart';
import 'package:store_app/layers/presentation/detail/notifier/detail_notifier.dart';
import 'package:store_app/layers/presentation/main/notifier/account_notifier.dart';
import 'package:store_app/layers/presentation/main/notifier/catalogue_notifier.dart';
import 'package:store_app/layers/presentation/main/notifier/favorite_notifier.dart';
import 'package:store_app/layers/presentation/main/notifier/main_notifier.dart';

void main() async {
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginNotifier>(
          create: (_) => di.sl<LoginNotifier>(),
        ),
        ChangeNotifierProvider<RegisterNotifier>(
          create: (_) => di.sl<RegisterNotifier>(),
        ),

        ChangeNotifierProvider<MainNotifier>(
          create: (_) => di.sl<MainNotifier>(),
        ),
        ChangeNotifierProvider<CatalogueNotifier>(
          create: (_) => di.sl<CatalogueNotifier>(),
        ),
        ChangeNotifierProvider<FavoriteNotifier>(
          create: (_) => di.sl<FavoriteNotifier>(),
        ),
        ChangeNotifierProvider<AccountNotifier>(
          create: (_) => di.sl<AccountNotifier>(),
        ),

        ChangeNotifierProvider<AboutNotifier>(
          create: (_) => di.sl<AboutNotifier>(),
        ),
        ChangeNotifierProvider<EditNotifier>(
          create: (_) => di.sl<EditNotifier>(),
        ),
        ChangeNotifierProvider<SecurityNotifier>(
          create: (_) => di.sl<SecurityNotifier>(),
        ),

        ChangeNotifierProvider<DetailNotifier>(
          create: (_) => di.sl<DetailNotifier>(),
        ),

        ChangeNotifierProvider<CartNotifier>(
          create: (_) => di.sl<CartNotifier>(),
        ),
      ],
      child: MaterialApp(
        title: 'KitStore',
        theme: ThemeData(
          primarySwatch: colorPrimary,
          accentColor: colorAccent,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Poppins',
          appBarTheme: AppBarTheme(
            actionsIconTheme: IconThemeData(
                color: colorAccent
            ),
            iconTheme: IconThemeData(
              color: colorAccent
            ),
          )
        ),
        home: SplashPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
