import 'package:flutter/material.dart';
import 'package:store_app/core/config/constants.dart';

class ItemCartBrand extends StatefulWidget {
  const ItemCartBrand({Key key}) : super(key: key);

  @override
  _ItemCartBrandState createState() => _ItemCartBrandState();
}

class _ItemCartBrandState extends State<ItemCartBrand> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Checkbox(
                activeColor: colorPrimary,
                value: isChecked,
                onChanged: (value) {
                  setState(() => isChecked = value);
                }
              ),

              Container(
                width: 30,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    child: Image.asset(
                      "assets/images/no_image.png",
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                ),
              ),
              SizedBox(width: 8),
              Text(
                "Brand",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
