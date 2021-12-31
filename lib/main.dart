import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/core/config/constants.dart';
import 'package:store_app/layers/presentation/auth/notifier/auth_notifier.dart';
import 'package:store_app/core/di/injection_container.dart' as di;
import 'package:store_app/layers/presentation/auth/page/splash_page.dart';
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
        ChangeNotifierProvider<AuthNotifier>(
          create: (_) => di.sl<AuthNotifier>(),
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
      ],
      child: MaterialApp(
        title: 'store app',
        theme: ThemeData(
          primarySwatch: colorPrimary,
          accentColor: colorAccent,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
