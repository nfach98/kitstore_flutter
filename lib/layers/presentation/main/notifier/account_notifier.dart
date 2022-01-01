import 'package:flutter/material.dart';
import 'package:store_app/core/usecase/usecase.dart';
import 'package:store_app/layers/domain/entities/user.dart';
import 'package:store_app/layers/domain/usecases/user/get_logged_in_user_usecase.dart';
import 'package:store_app/layers/domain/usecases/user/logout_usecase.dart';

class AccountNotifier with ChangeNotifier {
  final GetLoggedInUserUsecase _loggedInUserUsecase;
  final LogoutUsecase _logoutUsecase;

  AccountNotifier({
    @required GetLoggedInUserUsecase loggedInUserUsecase,
    @required LogoutUsecase logoutUsecase,
  }) : _loggedInUserUsecase = loggedInUserUsecase,
        _logoutUsecase = logoutUsecase;

  User user;
  bool isLoadingUser = true;

  Future<bool> logout() async {
    bool status;

    final result = await _logoutUsecase(NoParams());

    result.fold(
      (error) { },
      (success) {
        status = success;
      }
    );

    notifyListeners();
    return status;
  }

  Future<void> getLoggedInUser() async {
    isLoadingUser = true;
    notifyListeners();

    final result = await _loggedInUserUsecase(NoParams());

    result.fold(
      (error) { },
      (success) {
        user = success;
      }
    );

    isLoadingUser = false;
    notifyListeners();
  }

  reset() {
    user = null;
    isLoadingUser = true;

    notifyListeners();
  }
}