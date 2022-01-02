import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:store_app/layers/domain/entities/product.dart';
import 'package:store_app/layers/presentation/detail/page/detail_page.dart';
import 'package:store_app/layers/presentation/main/notifier/favorite_notifier.dart';
import 'package:provider/provider.dart';
import 'package:store_app/layers/presentation/main/notifier/main_notifier.dart';
import 'package:store_app/layers/presentation/kit_store_button.dart';

import '../../kit_store_item_list.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final products = context.select((FavoriteNotifier n) => n.listProduct);
    final isLoading = context.select((FavoriteNotifier n) => n.isLoadingProduct);
    final isKeepLoading = context.select((FavoriteNotifier n) => n.isKeepLoadingProduct);

    return Scaffold(
      appBar: _buildAppBar(
        products: products
      ),
      body: _buildList(
        products: products,
        isLoading: isLoading,
        isKeepLoading: isKeepLoading
      ),
    );
  }

  Widget _buildAppBar({List<Product> products}) {
    return AppBar(
      title: Text("Favorite (${products.length})"),
    );
  }

  Widget _buildList({List<Product> products, bool isLoading, bool isKeepLoading}) {
    if (products == null || (products.isEmpty && isLoading)) {
      products = List(12);
    }

    if (products.isNotEmpty) {
      return SingleChildScrollView(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: products.length,
                itemBuilder: (_, index) {
                  if (products[index] != null) {
                    return KitStoreItemList(
                      product: products[index],
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => DetailPage(
                              product: products[index],
                            ))
                        );
                      },
                      onFavoritePressed: (id, isFavorite) {
                        if (isFavorite == 0) {
                          return context.read<FavoriteNotifier>().addFavorite(id: id.toString());
                        }
                        else {
                          return context.read<FavoriteNotifier>().deleteFavorite(id: id.toString());
                        }
                      },
                    );
                  }

                  return Shimmer.fromColors(
                    baseColor: Colors.grey[400],
                    highlightColor: Colors.white,
                    child: KitStoreItemList(
                      onPressed: () { },
                    ),
                  );
                },
                separatorBuilder: (_, index) => SizedBox(height: 12),
              ),
            ),
            if (isKeepLoading) Container(
              child: CircularProgressIndicator(),
            ),
            SizedBox(height: 12),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/images/not_found.png",
            height: 120,
          ),

          SizedBox(height: 12),
          Text(
            "You don't have any favorite products yet",
            style: TextStyle(
              fontSize: 16,
            ),
          ),

          SizedBox(height: 20),
          KitStoreButton(
            text: "Search your favorite",
            onPressed: () {
              context.read<MainNotifier>().setSelectedIndex(0);
            },
          )
        ],
      ),
    );
  }
}
