import 'package:flutter/material.dart';
import 'package:store_app/core/config/constants.dart';

class ItemAccountSetting extends StatelessWidget {
  final String text;
  final Widget icon;
  final Color color;
  final Function onPressed;

  const ItemAccountSetting({Key key, this.text, this.icon, this.color, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed ?? () { },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 20
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: icon,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  text,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 16,
                    color: color ?? Colors.black
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: colorAccent,
          )
        ],
      ),
    );
  }
}
