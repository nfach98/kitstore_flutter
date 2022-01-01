import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:store_app/core/usecase/usecase.dart';
import 'package:store_app/layers/domain/entities/user.dart';
import 'package:store_app/layers/domain/usecases/user/get_logged_in_user_usecase.dart';
import 'package:store_app/layers/domain/usecases/user/logout_usecase.dart';

class AboutNotifier with ChangeNotifier {
  PackageInfo packageInfo;

  Future<void> getPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
    notifyListeners();
  }

  reset() {
    packageInfo = null;

    notifyListeners();
  }
}