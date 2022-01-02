import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:store_app/core/usecase/usecase.dart';
import 'package:store_app/layers/domain/entities/user.dart';
import 'package:store_app/layers/domain/usecases/user/get_logged_in_user_usecase.dart';
import 'package:store_app/layers/domain/usecases/user/update_user_usecase.dart';

class SecurityNotifier with ChangeNotifier {
  final GetLoggedInUserUsecase _loggedInUserUsecase;
  final UpdateUserUsecase _updateUserUsecase;

  SecurityNotifier({
    @required GetLoggedInUserUsecase loggedInUserUsecase,
    @required UpdateUserUsecase updateUserUsecase,
  }) : _loggedInUserUsecase = loggedInUserUsecase,
        _updateUserUsecase = updateUserUsecase;

  User user;
  bool isLoadingUser = true;

  Future<User> getLoggedInUser() async {
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

    return user;
  }

  Future<int> updateUser({String password}) async {
    int status;

    final result = await _updateUserUsecase(UpdateUserParams(
      password: password,
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

  reset() {
    user = null;
    isLoadingUser = true;

    notifyListeners();
  }
}