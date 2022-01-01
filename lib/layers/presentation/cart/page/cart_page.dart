import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:store_app/core/config/constants.dart';
import 'package:store_app/core/config/globals.dart';
import 'package:store_app/layers/domain/entities/brand.dart';
import 'package:store_app/layers/domain/entities/product.dart';
import 'package:store_app/layers/presentation/cart/notifier/cart_notifier.dart';
import 'package:store_app/layers/presentation/cart/widget/item_cart_brand.dart';
import 'package:store_app/layers/presentation/cart/widget/item_cart_product.dart';
import 'package:darq/darq.dart';
import 'package:store_app/layers/presentation/detail/page/detail_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<CartNotifier>().reset();
      context.read<CartNotifier>().getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final brands = context.select((CartNotifier n) => n.listBrand);
    final products = context.select((CartNotifier n) => n.listProduct);
    final isLoading = context.select((CartNotifier n) => n.isLoadingProduct);

    final selected = context.select((CartNotifier n) => n.listSelected);

    final total = context.select((CartNotifier n) => n.grandTotal);

    return Scaffold(
      appBar: _buildAppBar(products: products),
      body: Column(
        children: [
          Expanded(
            child: _buildList(
              brands: brands,
              products: products,
              isLoading: isLoading,

              selected: selected
            )
          ),

          if (products != null && selected != null) _buildTotal(
            products: products,
            selected: selected,

            total: total
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar({List<Product> products}) {
    return AppBar(
      title: Text("Cart (${products == null ? "" : products.length})"),
    );
  }

  Widget _buildList({List<Brand> brands, List<Product> products, bool isLoading, List<int> selected}) {
    if (products == null || (products.isEmpty && isLoading)) {
      products = List(12);
    }

    if (brands == null) {
      brands = List(12);
    }

    if (products.isNotEmpty) {
      return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: brands.length,
                itemBuilder: (_, index) {
                  if (brands[index] != null) {
                    List<Product> prod = products.where((element) => element.idBrand == brands[index].id).toList();
                    var brandSelected = prod.where((element) => selected.contains(element.id)).toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ItemCartBrand(
                          brand: brands[index],
                          isSelected: brandSelected.length == prod.length,
                          onChanged: (value) {
                            if (value) {
                              context.read<CartNotifier>().addSelectedBrand(brands[index].id);
                            }
                            else {
                              context.read<CartNotifier>().removeSelectedBrand(brands[index].id);
                            }
                          },
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: prod.length,
                          itemBuilder: (_, index) {
                            return ItemCartProduct(
                              product: prod[index],
                              isSelected: selected.contains(prod[index].id),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => DetailPage(
                                    product: products[index],
                                  ))
                                );
                              },
                            );
                          },
                          separatorBuilder: (_, index) => SizedBox(height: 12),
                        ),

                        SizedBox(height: 8),
                        Text(
                          "Subtotal: ${App.currency(context, prod.map((e) => e.price * e.qty).sum())}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    );
                  }

                  return Shimmer.fromColors(
                    baseColor: Colors.grey[400],
                    highlightColor: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ItemCartBrand(),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 1,
                          itemBuilder: (_, index) {
                            return ItemCartProduct();
                          },
                          separatorBuilder: (_, index) => SizedBox(height: 12),
                        ),

                        SizedBox(height: 8),
                        Text(
                          "Subtotal",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (_, index) => SizedBox(height: 20),
              ),
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
            "You don't have any product in cart yet",
            style: TextStyle(
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTotal({List<Product> products, List<int> selected, int total}) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          Checkbox(
            activeColor: colorPrimary,
            value: selected.isNotEmpty && products.isNotEmpty && selected.length == products.length,
            onChanged: (value) {

            }
          ),
          Text(
            "Select all",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Grand Total",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  App.currency(context, total),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorPrimary
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
