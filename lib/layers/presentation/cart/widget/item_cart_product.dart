import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/core/config/constants.dart';
import 'package:store_app/core/config/globals.dart';
import 'package:store_app/layers/domain/entities/product.dart';
import 'package:store_app/layers/presentation/cart/notifier/cart_notifier.dart';

class ItemCartProduct extends StatefulWidget {
  final Product product;
  final Function onPressed;
  final bool isSelected;

  const ItemCartProduct({Key key, this.onPressed, this.product, this.isSelected}) : super(key: key);

  @override
  _ItemCartProductState createState() => _ItemCartProductState();
}

class _ItemCartProductState extends State<ItemCartProduct> {
  bool isSelected = false;
  int quantity = 1;

  @override
  void initState() {
    super.initState();

    if (widget.isSelected != null) {
      isSelected = widget.isSelected;
    }

    if (widget.product != null) {
      // isSelected = widget.product.isSelected == 1;
      quantity = widget.product.qty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed ?? () { },
      child: Container(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              activeColor: colorPrimary,
              value: isSelected,
              onChanged: (value) {
                context.read<CartNotifier>().updateCart(
                  id: widget.product.id.toString(),
                  isSelected: value,
                  qty: quantity
                );
                if (value) {
                  context.read<CartNotifier>().addSelected(widget.product.id);
                }
                else {
                  context.read<CartNotifier>().removeSelected(widget.product.id);
                }
                setState(() => isSelected = value);
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
                          context.read<CartNotifier>().deleteCart(id: widget.product.id.toString());
                        },
                        borderRadius: BorderRadius.circular(20.0),
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.delete_outline,
                            size: 20.0,
                            color: Colors.red,
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
            widget.product == null
              ? "assets/images/no_image.png"
              : widget.product.image,
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
            widget.product == null ? "" : widget.product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold
            ),
          ),

          SizedBox(height: 4),
          Text(
            App.currency(context, widget.product == null ? 0 : widget.product.price),
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
            if (quantity > 1) {
              context.read<CartNotifier>().updateCart(
                id: widget.product.id.toString(),
                isSelected: isSelected,
                qty: quantity - 1
              ).then((status) {
                if (status != null) {
                  setState(() => quantity = quantity - 1);
                }
              });
            }
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
            context.read<CartNotifier>().updateCart(
              id: widget.product.id.toString(),
              isSelected: isSelected,
              qty: quantity + 1
            ).then((status) {
              if (status != null) {
                setState(() => quantity = quantity + 1);
              }
            });
          },
        ),
      ],
    );
  }
}