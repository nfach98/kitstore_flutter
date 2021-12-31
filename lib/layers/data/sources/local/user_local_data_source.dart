import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/core/sqlite/sqlite_helper.dart';
import 'package:store_app/layers/data/models/user_model.dart';

abstract class UserLocalDataSource {
  Future<UserModel> login({String email, String password});

  Future<int> register({String name, String email, String password});

  Future<bool> logout();

  Future<UserModel> getLoggedInUser();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  SQLiteHelper helper = SQLiteHelper();

  @override
  Future<UserModel> login({String email, String password}) async {
    var dbClient = await helper.db;
    List<Map<String, dynamic>> maps = await dbClient.query('users',
      where: "email = ? AND password = ?",
      whereArgs: [email, password]
    );

    if (maps.isNotEmpty) {
      var prefs = await SharedPreferences.getInstance();
      prefs.setString('user', json.encode(maps.first));
      print(maps.first);
    }

    return maps.isNotEmpty ? UserModel.fromJson(maps.first) : null;
  }

  @override
  Future<int> register({String name, String email, String password}) async {
    var dbClient = await helper.db;
    Map<String, dynamic> map = {
      'name' : name,
      'email' : email,
      'password' : password
    };

    var prefs = await SharedPreferences.getInstance();
    var status = await dbClient.insert('users', map);
    if (status != null) {
      map["id"] = status;
    }
    prefs.setString('user', json.encode(map));
    return status;
  }

  @override
  Future<bool> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove("user");
  }

  @override
  Future<UserModel> getLoggedInUser() async {
    var prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('user');

    Map<String, dynamic> map = {};
    if (stringValue != null) map = json.decode(stringValue);

    return map.isNotEmpty ? UserModel.fromJson(map) : null;
  }
}