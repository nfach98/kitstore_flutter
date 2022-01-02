import 'package:flutter/material.dart';
import 'package:store_app/core/usecase/usecase.dart';
import 'package:store_app/layers/domain/entities/user.dart';
import 'package:store_app/layers/domain/usecases/user/get_logged_in_user_usecase.dart';
import 'package:store_app/layers/domain/usecases/user/login_usecase.dart';

class LoginNotifier with ChangeNotifier {
  final GetLoggedInUserUsecase _loggedInUserUsecase;
  final LoginUsecase _loginUsecase;

  LoginNotifier({
    @required GetLoggedInUserUsecase loggedInUserUsecase,
    @required LoginUsecase loginUsecase,
  }) : _loggedInUserUsecase = loggedInUserUsecase,
        _loginUsecase = loginUsecase;

  bool isHidePassword = true;

  Future<User> login({String email, String password}) async {
    User user;

    final result = await _loginUsecase(LoginParams(
      email: email,
      password: password
    ));

    result.fold(
      (error) { },
      (success) {
        user = success;
      }
    );

    notifyListeners();
    return user;
  }

  Future<User> getLoggedInUser() async {
    User user;

    final result = await _loggedInUserUsecase(NoParams());

    result.fold(
      (error) { },
      (success) {
        user = success;
      }
    );

    notifyListeners();
    return user;
  }

  setHidePassword(bool value) {
    isHidePassword = value;
    notifyListeners();
  }

  reset() {
    isHidePassword = true;
    notifyListeners();
  }
}