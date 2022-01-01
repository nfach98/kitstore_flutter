import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/layers/presentation/auth/notifier/auth_notifier.dart';
import 'package:store_app/layers/presentation/auth/page/login_page.dart';
import 'package:store_app/layers/presentation/main/page/main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  var duration = const Duration(milliseconds: 3000);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Timer(duration, () {
        context.read<AuthNotifier>().getLoggedInUser().then((user) {
          if (user != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => MainPage())
            );
          }

          else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LoginPage())
            );
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Positioned.fill(
                left: 0,
                top: 0,
                right: 0,
                bottom: 0,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Image.asset(
                      "assets/images/logo_long_color.png",
                      height: 120,
                    ),
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
