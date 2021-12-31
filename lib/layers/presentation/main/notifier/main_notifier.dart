import 'package:flutter/material.dart';
import 'package:store_app/layers/presentation/main/page/account_page.dart';
import 'package:store_app/layers/presentation/main/page/catalogue_page.dart';
import 'package:store_app/layers/presentation/main/page/favorite_page.dart';

class MainNotifier with ChangeNotifier {

  int selectedIndex = 0;
  List<Widget> pages = [
    CataloguePage(),
    FavoritePage(),
    AccountPage()
  ];

  setSelectedIndex(int value) {
    selectedIndex = value;
    notifyListeners();
  }
}