import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/core/config/constants.dart';
import 'package:store_app/layers/domain/entities/product.dart';
import 'package:store_app/layers/presentation/detail/notifier/detail_notifier.dart';
import 'package:store_app/layers/presentation/store_app_button.dart';


class BottomSheetCart extends StatefulWidget {
  final Product product;

  const BottomSheetCart({Key key, this.product}) : super(key: key);

  @override
  _BottomSheetCartState createState() => _BottomSheetCartState();
}

class _BottomSheetCartState extends State<BottomSheetCart> {
  int qty = 1;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      qty = widget.product.qty != null && widget.product.qty > 0 ? widget.product.qty : 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Quantity",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 20),

            FractionallySizedBox(
              widthFactor: 1,
              child: _buildQuantity()
            ),
            SizedBox(height: 32),

            FractionallySizedBox(
              widthFactor: 1,
              child: StoreAppButton(
                text: "Add to cart",
                icon: Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  context.read<DetailNotifier>().addCart(
                    id: widget.product.id.toString(),
                    qty: qty
                  ).then((status) {
                    if (status != null) {
                      // Navigator.pop(context);
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantity() {
    return Row(
      children: [
        IconButton(
          splashRadius: 24.0,
          icon: Icon(
            Icons.remove_circle_outline,
            size: 24.0,
            color: qty == 1 ? Colors.grey : colorPrimary,
          ),
          onPressed: () {
            if (qty > 1) setState(() => qty = qty - 1);
          },
        ),

        Expanded(
          child: Text(
            qty.toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
          ),
        ),

        IconButton(
          splashRadius: 24.0,
          icon: Icon(
            Icons.add_circle_outline,
            size: 24.0,
            color: colorPrimary,
          ),
          onPressed: () {
            setState(() => qty = qty + 1);
          },
        ),
      ],
    );
  }
}
