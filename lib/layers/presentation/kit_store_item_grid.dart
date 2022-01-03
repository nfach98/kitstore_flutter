import 'package:flutter/material.dart';
import 'package:store_app/core/config/constants.dart';
import 'package:store_app/core/config/globals.dart';
import 'package:store_app/layers/domain/entities/product.dart';

class KitStoreItemGrid extends StatefulWidget {
  final Product product;
  final int isFavorite;
  final Function onPressed;
  final Function(int, int) onFavoritePressed;

  const KitStoreItemGrid({Key key, this.onPressed, this.product, this.onFavoritePressed, this.isFavorite}) : super(key: key);

  @override
  _KitStoreItemGridState createState() => _KitStoreItemGridState();
}

class _KitStoreItemGridState extends State<KitStoreItemGrid> {
  int isFavorite = 0;

  @override
  void initState() {
    super.initState();
    // if (widget.product != null) {
    //   isFavorite = widget.product.isFavorite;
    // }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isFavorite != null) {
      isFavorite = widget.isFavorite;
    }

    return GestureDetector(
      onTap: widget.onPressed ?? () { },
      child: Container(
        color: Colors.transparent,
        height: 332,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(),
                _buildInfo()
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: Icon(
                  Icons.favorite,
                  size: 24.0,
                  color: isFavorite == 1 ? Colors.pink : Colors.grey,
                ),
                onPressed: () {
                  if (widget.product != null && widget.onFavoritePressed != null) {
                    widget.onFavoritePressed(widget.product.id, widget.product.isFavorite);
                    // widget.onFavoritePressed(widget.product.id, widget.product.isFavorite).then((status) {
                    //   if (status != null) {
                    //     context.read<CatalogueNotifier>().updateProduct(
                    //       id: widget.product.id,
                    //       isFavorite: isFavorite == 1 ? 0 : 1
                    //     );
                    //     context.read<FavoriteNotifier>().reset();
                    //     context.read<FavoriteNotifier>().getProducts();
                    //
                    //     if (isFavorite == 0) {
                    //       Toast.show(
                    //         widget.product.name + " is added to favorite",
                    //         context,
                    //         duration: Toast.LENGTH_LONG,
                    //         gravity: Toast.BOTTOM,
                    //         backgroundRadius: 32,
                    //         textColor: colorPrimary,
                    //         backgroundColor: colorAccent
                    //       );
                    //     }
                    //     else {
                    //       Toast.show(
                    //         widget.product.name + " is removed from favorite",
                    //         context,
                    //         duration: Toast.LENGTH_LONG,
                    //         gravity: Toast.BOTTOM,
                    //         backgroundRadius: 32,
                    //         textColor: colorPrimary,
                    //         backgroundColor: colorAccent
                    //       );
                    //     }
                    //
                    //     setState(() => isFavorite = isFavorite == 1 ? 0 : 1);
                    //   }
                    // });
                  }
                },
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return AspectRatio(
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
      )
    );
  }

  Widget _buildInfo() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
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
          Row(
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
          )
        ],
      ),
    );
  }
}