import 'package:flutter/material.dart';
import 'package:store_app/core/usecase/usecase.dart';
import 'package:store_app/layers/domain/entities/user.dart';
import 'package:store_app/layers/domain/usecases/user/get_logged_in_user_usecase.dart';
import 'package:store_app/layers/domain/usecases/user/login_usecase.dart';
import 'package:store_app/layers/domain/usecases/user/logout_usecase.dart';
import 'package:store_app/layers/domain/usecases/user/register_usecase.dart';

class AuthNotifier with ChangeNotifier {
  final GetLoggedInUserUsecase _loggedInUserUsecase;
  final LoginUsecase _loginUsecase;
  final LogoutUsecase _logoutUsecase;
  final RegisterUsecase _registerUsecase;

  AuthNotifier({
    @required GetLoggedInUserUsecase loggedInUserUsecase,
    @required LoginUsecase loginUsecase,
    @required LogoutUsecase logoutUsecase,
    @required RegisterUsecase registerUsecase,
  }) : _loggedInUserUsecase = loggedInUserUsecase,
        _loginUsecase = loginUsecase,
        _logoutUsecase = logoutUsecase,
        _registerUsecase = registerUsecase;

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

  Future<int> register({String name, String email, String password}) async {
    int status;

    final result = await _registerUsecase(RegisterParams(
      name: name,
      email: email,
      password: password
    ));

    result.fold(
      (error) { },
      (success) {
        status = success;
      }
    );

    notifyListeners();
    return status;
  }

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
}