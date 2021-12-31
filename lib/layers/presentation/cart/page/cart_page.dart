import 'package:flutter/material.dart';
import 'package:store_app/core/config/constants.dart';
import 'package:store_app/layers/presentation/main/widget/item_cart_brand.dart';
import 'package:store_app/layers/presentation/main/widget/item_cart_product.dart';

import '../../store_app_item_list.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: _buildList()
          ),
          _buildTotal(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text("Cart (12)"),
    );
  }

  Widget _buildList() {
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
              itemCount: 4,
              itemBuilder: (_, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ItemCartBrand(),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 2,
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
                );
              },
              separatorBuilder: (_, index) => SizedBox(height: 20),
            ),
          ),
          // if (isKeepLoading)
          //   Container(
          //     child: CircularProgressIndicator(),
          //   ),
          SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildTotal() {
    return Container(
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          Checkbox(
            activeColor: colorPrimary,
            value: false,
            onChanged: (value) { }
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
                  "Rp",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold
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
