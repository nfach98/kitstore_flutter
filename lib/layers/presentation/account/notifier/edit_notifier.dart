import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:store_app/core/usecase/usecase.dart';
import 'package:store_app/layers/domain/entities/user.dart';
import 'package:store_app/layers/domain/usecases/user/get_logged_in_user_usecase.dart';
import 'package:store_app/layers/domain/usecases/user/update_user_usecase.dart';

class EditNotifier with ChangeNotifier {
  final GetLoggedInUserUsecase _loggedInUserUsecase;
  final UpdateUserUsecase _updateUserUsecase;

  EditNotifier({
    @required GetLoggedInUserUsecase loggedInUserUsecase,
    @required UpdateUserUsecase updateUserUsecase,
  }) : _loggedInUserUsecase = loggedInUserUsecase,
        _updateUserUsecase = updateUserUsecase;

  User user;
  bool isLoadingUser = true;

  File image;

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

  Future<int> updateUser({String name, String email, String oldAvatar}) async {
    int status;
    String filename;

    if (image != null) {
      Directory appDocDirectory = await getApplicationDocumentsDirectory();
      await Directory(appDocDirectory.path + '/images').create(recursive: true).then((directory) {
        filename = directory.path + "/${user.id}_${DateFormat("yyyyMMddHHmmss").format(DateTime.now())}.${image.path.split('.').last}";
        print(filename);
      });
    }

    final result = await _updateUserUsecase(UpdateUserParams(
      name: name,
      email: email,
      avatar: filename
    ));

    result.fold(
      (error) { },
      (success) {
        status = success;
        if (filename != null) {
          if (oldAvatar != null && oldAvatar.isNotEmpty) {
            File(oldAvatar).delete();
          }
          image.copy(filename);
        }
      }
    );

    notifyListeners();
    return status;
  }

  setImage(File value) {
    image = value;
    notifyListeners();
  }

  reset() {
    user = null;
    isLoadingUser = true;

    image = null;

    notifyListeners();
  }
}