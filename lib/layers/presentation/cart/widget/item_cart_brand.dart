import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/core/config/constants.dart';
import 'package:store_app/layers/domain/entities/brand.dart';
import 'package:store_app/layers/presentation/cart/notifier/cart_notifier.dart';

class ItemCartBrand extends StatefulWidget {
  final Brand brand;
  final bool isSelected;

  const ItemCartBrand({Key key, this.brand, this.isSelected}) : super(key: key);

  @override
  _ItemCartBrandState createState() => _ItemCartBrandState();
}

class _ItemCartBrandState extends State<ItemCartBrand> {
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    if (widget.isSelected != null) {
      isSelected = widget.isSelected;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSelected != null) {
      isSelected = widget.isSelected;
    }

    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Checkbox(
                      activeColor: colorPrimary,
                      value: isSelected,
                      onChanged: (value) {
                        context.read<CartNotifier>().updateCart(
                          idBrand: widget.brand.id.toString(),
                          isSelected: value,
                        );
                        if (value) {
                          context.read<CartNotifier>().addSelectedBrand(widget.brand.id);
                        }
                        else {
                          context.read<CartNotifier>().removeSelectedBrand(widget.brand.id);
                        }
                      }
                    ),
                    Container(
                      width: 30,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          child: Image.asset(
                            widget.brand == null
                                ? "assets/images/no_image.png"
                                : widget.brand.image,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      widget.brand == null ? "" : widget.brand.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                )
              ),

              InkWell(
                onTap: () {
                  context.read<CartNotifier>().deleteCart(
                    idBrand: widget.brand.id.toString()
                  );
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
          )
        ],
      ),
    );
  }
}
