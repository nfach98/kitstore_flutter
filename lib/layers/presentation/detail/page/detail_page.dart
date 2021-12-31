import 'package:flutter/material.dart';
import 'package:store_app/core/config/constants.dart';
import 'package:store_app/core/config/globals.dart';
import 'package:store_app/layers/domain/entities/product.dart';
import 'package:store_app/layers/presentation/store_app_button.dart';

class DetailPage extends StatefulWidget {
  final Product product;

  const DetailPage({Key key, this.product}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: App.getHeight(context),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImage(),

                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitle(),

                          SizedBox(height: 8),
                          _buildPrice(),

                          SizedBox(height: 20),
                          _buildBrand(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                child: _buildAppBar()
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: _buildAddToCart(),
                )
              )
            ],
          ),
        )
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(
        color: colorPrimary
      ),
      // title: Text(
      //   widget.product == null ? "" : widget.product.name,
      //   style: TextStyle(
      //     color: colorPrimary
      //   ),
      // ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.favorite,
            size: 24.0,
            color: Colors.grey,
          ),
          onPressed: () {

          },
        )
      ],
    );
  }

  Widget _buildImage() {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(12)
        ),
        child: Image.asset(
          widget.product == null
            ? "assets/images/no_image.png"
            : widget.product.image,
          width: double.infinity,
          fit: BoxFit.contain,
        ),
      )
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.product == null ? "" : widget.product.name,
      style: TextStyle(
        fontSize: 20,
      ),
    );
  }

  Widget _buildPrice() {
    return Text(
      App.currency(context, widget.product == null ? 0 : widget.product.price),
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: colorPrimary
      ),
    );
  }

  Widget _buildBrand() {
    return Row(
      children: [
        Container(
          width: 48,
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
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildAddToCart() {
    return StoreAppButton(
      text: "Add to cart",
      icon: Padding(
        padding: EdgeInsets.only(right: 8),
        child: Icon(
          Icons.shopping_cart,
          color: Colors.white,
        ),
      ),
      onPressed: () {

      },
    );
  }
}
