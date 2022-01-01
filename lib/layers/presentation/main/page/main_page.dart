import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/core/config/constants.dart';
import 'package:store_app/layers/presentation/cart/notifier/cart_notifier.dart';
import 'package:store_app/layers/presentation/main/notifier/account_notifier.dart';
import 'package:store_app/layers/presentation/main/notifier/catalogue_notifier.dart';
import 'package:store_app/layers/presentation/main/notifier/favorite_notifier.dart';
import 'package:store_app/layers/presentation/main/notifier/main_notifier.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<MainNotifier>().setSelectedIndex(0);

      context.read<CatalogueNotifier>().reset();
      context.read<CatalogueNotifier>().getProducts();
      context.read<CatalogueNotifier>().getBrands();

      context.read<FavoriteNotifier>().reset();
      context.read<FavoriteNotifier>().getProducts();

      context.read<AccountNotifier>().reset();
      context.read<AccountNotifier>().getLoggedInUser();

      context.read<CartNotifier>().reset();
      context.read<CartNotifier>().getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = context.select((MainNotifier n) => n.pages);
    final selectedPage = context.select((MainNotifier n) => n.selectedIndex);

    return Scaffold(
      body: LayoutBuilder(
        builder: (_, constraint) => pages[selectedPage],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(
        index: selectedPage
      ),
    );
  }

  Widget _buildBottomNavigationBar({int index}) {
    return BottomNavigationBar(
      backgroundColor: colorPrimary,
      selectedItemColor: colorAccent,
      currentIndex: index,
      showUnselectedLabels: false,
      onTap: (index) {
        context.read<MainNotifier>().setSelectedIndex(index);
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag),
          label: "Catalogue",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: "Favorite",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Account",
        ),
      ]
    );
  }
}
