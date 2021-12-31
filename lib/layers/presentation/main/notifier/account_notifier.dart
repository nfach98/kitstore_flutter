import 'package:flutter/material.dart';
import 'package:store_app/layers/domain/usecases/user/logout_usecase.dart';
import 'package:store_app/layers/presentation/main/page/account_page.dart';
import 'package:store_app/layers/presentation/main/page/catalogue_page.dart';
import 'package:store_app/layers/presentation/main/page/favorite_page.dart';

class AccountNotifier with ChangeNotifier {
  final LogoutUsecase _logoutUsecase;

  AccountNotifier({
    @required LogoutUsecase logoutUsecase,
  }) : _logoutUsecase = logoutUsecase;


}