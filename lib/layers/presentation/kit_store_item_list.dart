import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/core/config/constants.dart';
import 'package:store_app/core/config/globals.dart';
import 'package:store_app/layers/domain/entities/product.dart';
import 'package:toast/toast.dart';
import 'main/notifier/catalogue_notifier.dart';
import 'main/notifier/favorite_notifier.dart';

class KitStoreItemList extends StatefulWidget {
  final Product product;
  final Function onPressed;
  final Future<int> Function(int, int) onFavoritePressed;

  const KitStoreItemList({Key key, this.onPressed, this.product, this.onFavoritePressed}) : super(key: key);

  @override
  _KitStoreItemListState createState() => _KitStoreItemListState();
}

class _KitStoreItemListState extends State<KitStoreItemList> {
  int isFavorite = 0;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      isFavorite = widget.product.isFavorite;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed ?? () { },
      child: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            SizedBox(width: 12),
            Expanded(
              child: _buildInfo()
            ),
            IconButton(
              icon: Icon(
                Icons.favorite,
                size: 24.0,
                color: isFavorite == 1 ? Colors.pink : Colors.grey,
              ),
              onPressed: () {
                if (widget.product != null) {
                  widget.onFavoritePressed(widget.product.id, widget.product.isFavorite).then((status) {
                    if (status != null) {
                      context.read<CatalogueNotifier>().updateProduct(
                        id: widget.product.id,
                        isFavorite: isFavorite == 1 ? 0 : 1
                      );
                      context.read<FavoriteNotifier>().reset();
                      context.read<FavoriteNotifier>().getProducts();

                      if (isFavorite == 0) {
                        Toast.show(
                          widget.product.name + " is added to favorite",
                          context,
                          duration: Toast.LENGTH_LONG,
                          gravity: Toast.BOTTOM,
                          backgroundRadius: 32,
                          textColor: colorPrimary,
                          backgroundColor: colorAccent
                        );
                      }
                      else {
                        Toast.show(
                          widget.product.name + " is removed from favorite",
                          context,
                          duration: Toast.LENGTH_LONG,
                          gravity: Toast.BOTTOM,
                          backgroundRadius: 32,
                          textColor: colorPrimary,
                          backgroundColor: colorAccent
                        );
                      }

                      setState(() => isFavorite = isFavorite == 1 ? 0 : 1);
                    }
                  });
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: App.getWidth(context) * .3,
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          child: Image.asset(
            widget.product == null
              ? "assets/images/no_image.png"
              : widget.product.image,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Container(
      height: App.getWidth(context) * .3,
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

          SizedBox(height: 12),
          Text(
            App.currency(context, widget.product == null ? 0 : widget.product.price),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colorPrimary
            ),
          ),

          SizedBox(height: 20),
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 24,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      child: Image.asset(
                        widget.product == null
                          ? "assets/images/no_image.png"
                          : widget.product.brand.image,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  widget.product == null ? "" : widget.product.brand.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}