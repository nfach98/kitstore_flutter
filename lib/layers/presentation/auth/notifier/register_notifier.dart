import 'package:flutter/material.dart';
import 'package:store_app/layers/domain/usecases/user/register_usecase.dart';

class RegisterNotifier with ChangeNotifier {
  final RegisterUsecase _registerUsecase;

  RegisterNotifier({
    @required RegisterUsecase registerUsecase,
  }) : _registerUsecase = registerUsecase;

  bool isHidePassword = true;
  bool isHideConfirmPassword = true;

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

  setHidePassword(bool value) {
    isHidePassword = value;
    notifyListeners();
  }

  setHideConfirmPassword(bool value) {
    isHideConfirmPassword = value;
    notifyListeners();
  }

  reset() {
    isHidePassword = true;
    isHideConfirmPassword = true;
    notifyListeners();
  }
}