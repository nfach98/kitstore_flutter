import 'package:flutter/material.dart';
import 'package:store_app/core/config/constants.dart';
import 'package:store_app/core/config/globals.dart';
import 'package:store_app/layers/domain/entities/product.dart';
import 'package:store_app/layers/presentation/main/notifier/catalogue_notifier.dart';
import 'package:store_app/layers/presentation/main/notifier/favorite_notifier.dart';
import 'package:provider/provider.dart';

class StoreAppItemGrid extends StatefulWidget {
  final Product product;
  final Function onPressed;
  final Future<int> Function(int, int) onFavoritePressed;

  const StoreAppItemGrid({Key key, this.onPressed, this.product, this.onFavoritePressed}) : super(key: key);

  @override
  _StoreAppItemGridState createState() => _StoreAppItemGridState();
}

class _StoreAppItemGridState extends State<StoreAppItemGrid> {
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
        height: 320,
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
                  if (widget.product != null) {
                    widget.onFavoritePressed(widget.product.id, widget.product.isFavorite).then((status) {
                      if (status != null) {
                        context.read<CatalogueNotifier>().updateProduct(
                          id: widget.product.id,
                          isFavorite: isFavorite == 1 ? 0 : 1
                        );
                        context.read<FavoriteNotifier>().reset();
                        context.read<FavoriteNotifier>().getProducts();
                        setState(() => isFavorite = isFavorite == 1 ? 0 : 1);
                      }
                    });
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