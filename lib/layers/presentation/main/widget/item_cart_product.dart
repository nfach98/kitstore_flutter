import 'package:flutter/material.dart';
import 'package:store_app/core/config/constants.dart';
import 'package:store_app/core/config/globals.dart';

class ItemCartProduct extends StatefulWidget {
  // final Shoes shoes;
  // final List<ExchangeRate> exchangeRates;
  final Function onPressed;

  const ItemCartProduct({Key key, this.onPressed}) : super(key: key);

  @override
  _ItemCartProductState createState() => _ItemCartProductState();
}

class _ItemCartProductState extends State<ItemCartProduct> {
  bool isChecked = false;
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed ?? () { },
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              activeColor: colorPrimary,
              value: isChecked,
              onChanged: (value) {
                setState(() => isChecked = value);
              }
            ),

            _buildImage(),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildInfo()
                      ),
                      InkWell(
                        onTap: () {

                        },
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline,
                                size: 20.0,
                                color: Colors.red,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Delete",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildQuantity()
                      ],
                    ),
                  )
                ],
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: App.getWidth(context) * .2,
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          child: Image.asset(
            "assets/images/no_image.png",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Container(
      height: App.getWidth(context) * .2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Title",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold
            ),
          ),

          SizedBox(height: 4),
          Text(
            "Rp",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold
            ),
          ),
        ],
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
            color: quantity == 1 ? Colors.grey : colorPrimary,
          ),
          onPressed: () {
            if (quantity > 1) setState(() => quantity = quantity - 1);
          },
        ),

        SizedBox(
          width: App.getWidth(context) * 0.1,
          child: Text(
            quantity.toString(),
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
            setState(() => quantity = quantity + 1);
          },
        ),
      ],
    );
  }
}