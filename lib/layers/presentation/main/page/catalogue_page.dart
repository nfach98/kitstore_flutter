import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:store_app/core/config/constants.dart';
import 'package:store_app/layers/domain/entities/brand.dart';
import 'package:store_app/layers/domain/entities/product.dart';
import 'package:store_app/layers/presentation/cart/notifier/cart_notifier.dart';
import 'package:store_app/layers/presentation/cart/page/cart_page.dart';
import 'package:store_app/layers/presentation/detail/page/detail_page.dart';
import 'package:store_app/layers/presentation/main/notifier/catalogue_notifier.dart';
import 'package:store_app/layers/presentation/main/notifier/favorite_notifier.dart';
import 'package:store_app/layers/presentation/main/widget/bottom_sheet_filter.dart';
import 'package:store_app/layers/presentation/kit_store_item_grid.dart';
import 'package:toast/toast.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'package:provider/provider.dart';

import '../../kit_store_item_list.dart';
import '../../kit_store_text_field.dart';

class CataloguePage extends StatefulWidget {
  const CataloguePage({Key key}) : super(key: key);

  @override
  _CataloguePageState createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
  TextEditingController _searchController;
  ScrollController _scrollController;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        context.read<CatalogueNotifier>().getProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final modeView = context.select((CatalogueNotifier n) => n.modeView);

    final products = context.select((CatalogueNotifier n) => n.listProduct);
    final isLoadingProduct = context.select((CatalogueNotifier n) => n.isLoadingProduct);
    final isKeepLoadingProduct = context.select((CatalogueNotifier n) => n.isKeepLoadingProduct);

    final brands = context.select((CatalogueNotifier n) => n.listBrand);
    
    final selectedBrand = context.select((CatalogueNotifier n) => n.listSelectedBrand);
    final priceRange = context.select((CatalogueNotifier n) => n.rangePrice);

    final sorts = context.select((CatalogueNotifier n) => n.listSort);
    final selectedSort = context.select((CatalogueNotifier n) => n.sort);

    final cartProducts = context.select((CartNotifier n) => n.listProduct);

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
      },
      child: Scaffold(
        appBar: _buildAppBar(
          cartBadge: cartProducts == null ? 0 : cartProducts.length
        ),
        body: Column(
          children: [
            _buildFilterSort(
              modeView: modeView,

              brands: brands,
              selectedBrands: selectedBrand,

              priceRange: priceRange,

              sorts: sorts,
              selectedSort: selectedSort
            ),
            Expanded(
              child: _buildList(
                modeView: modeView,

                products: products,
                isLoading: isLoadingProduct,
                isKeepLoading: isKeepLoadingProduct
              )
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar({int cartBadge}) {
    return AppBar(
      title: Container(
        height: 36,
        child: KitStoreTextField(
          controller: _searchController,
          maxLines: 1,
          keyboardType: TextInputType.text,
          hintText: "Search product or brand",
          style: TextStyle(
            fontSize: 14
          ),
          prefixIcon: Icon(
            Icons.search,
            color: colorPrimary,
          ),
          suffixIcon: IconButton(
            splashRadius: 16,
            icon: Icon(
              Icons.close,
              size: 16,
              color: Colors.grey,
            ),
            onPressed: () {
              if (_searchController.text.isNotEmpty) {
                _searchController.clear();

                context.read<CatalogueNotifier>().resetList();
                context.read<CatalogueNotifier>().getProducts();
              }

              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
            },
          ),
          contentPadding: EdgeInsets.all(4),
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 0
            )
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 0
            )
          ),
          onChanged: (value) {
            context.read<CatalogueNotifier>().resetList();
            context.read<CatalogueNotifier>().getProducts(
              search: value.isNotEmpty ? value : null
            );
          },
        ),
      ),
      actions: [
        IconButton(
          icon: cartBadge <= 0
          ? Icon(
            Icons.shopping_cart,
          )
          : Badge(
            badgeContent: Text(
              cartBadge.toString(),
              style: TextStyle(
                color: Colors.white
              ),
            ),
            child: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
          ),
          onPressed: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CartPage())
            );
          }
        )
      ],
    );
  }

  Widget _buildFilterSort({
    int modeView,
    List<Brand> brands, List<Brand> selectedBrands,
    RangeValues priceRange,
    List<String> sorts, String selectedSort
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              showBottomSheetFilter(
                  brands: brands,
                  selectedBrands: selectedBrands,

                  priceRange: priceRange,

                  sorts: sorts,
                  selectedSort: selectedSort
              );
            },
            child: Row(
              children: [
                Icon(
                  Icons.filter_list,
                  size: 16.0,
                  color: colorPrimary,
                ),
                SizedBox(width: 4),
                Text(
                    "Filter & Sort",
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: colorPrimary,
                    )
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    modeView == 1 ? Icons.grid_view : Icons.list,
                    color: colorPrimary,
                  ),
                  onPressed: () {
                    context.read<CatalogueNotifier>().setModeView(modeView == 1 ? 0 : 1);
                  }
                )
              ],
            )
          )
        ],
      ),
    );
  }

  Widget _buildList({int modeView, List<Product> products, bool isLoading, bool isKeepLoading}) {
    if (products == null || (products.isEmpty && isLoading)) {
      products = List(12);
    }

    if (products.isNotEmpty) {
      return SingleChildScrollView(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: WaterfallFlow.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                    crossAxisCount: modeView == 0 ? 2 : 1,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                  ),
                  itemCount: products.length,
                  itemBuilder: (_, index) {
                    if (products[index] != null) {
                      return modeView == 0
                        ? KitStoreItemGrid(
                          product: products[index],
                          isFavorite: products[index].isFavorite,
                          onPressed: () {
                            FocusScopeNode currentFocus = FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => DetailPage(
                                product: products[index],
                              ))
                            );
                          },
                          onFavoritePressed: (id, isFavorite) {
                            Future<int> future;

                            if (isFavorite == 0) {
                              future = context.read<CatalogueNotifier>().addFavorite(id: id.toString());
                            }
                            else {
                              future = context.read<CatalogueNotifier>().deleteFavorite(id: id.toString());
                            }

                            future.then((status) {
                              if (status != null) {
                                context.read<CatalogueNotifier>().updateProduct(
                                  id: id,
                                  isFavorite: isFavorite == 1 ? 0 : 1
                                );
                                context.read<FavoriteNotifier>().reset();
                                context.read<FavoriteNotifier>().getProducts();

                                if (isFavorite == 0) {
                                  Toast.show(
                                    products[index].name + " is added to favorite",
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
                                    products[index].name + " is removed from favorite",
                                    context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM,
                                    backgroundRadius: 32,
                                    textColor: colorPrimary,
                                    backgroundColor: colorAccent
                                  );
                                }

                                setState(() => isFavorite = isFavorite == 1 ? 0 :1);
                              }
                            });
                          },
                        )
                        : KitStoreItemList(
                          product: products[index],
                          onPressed: () {
                            FocusScopeNode currentFocus = FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => DetailPage(
                                product: products[index],
                              ))
                            );
                          },
                          onFavoritePressed: (id, isFavorite) {
                            if (isFavorite == 0) {
                              return context.read<CatalogueNotifier>().addFavorite(id: id.toString());
                            }
                            else {
                              return context.read<CatalogueNotifier>().deleteFavorite(id: id.toString());
                            }
                          },
                        );
                    }

                    return Shimmer.fromColors(
                      baseColor: Colors.grey[400],
                      highlightColor: Colors.white,
                      child: modeView == 0
                        ? KitStoreItemGrid(
                          onPressed: () { },
                        )
                        : KitStoreItemList(
                          onPressed: () { },
                        ),
                    );
                  }
              ),
            ),
            if (isKeepLoading) Container(
              child: CircularProgressIndicator(),
            ),
            SizedBox(height: 12),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/images/not_found.png",
            height: 120,
          ),
          SizedBox(height: 12),
          Text(
            "Oops, we cannot find your search",
            style: TextStyle(
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }

  showBottomSheetFilter({
    List<Brand> brands, List<Brand> selectedBrands,
    RangeValues priceRange,
    List<String> sorts, String selectedSort
  }) {

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20)
                ),
              ),
              child: BottomSheetFilter(
                brands: brands,
                selectedBrands: selectedBrands,
                
                priceRange: priceRange,

                sorts: sorts,
                selectedSort: selectedSort,
              )
            )
          ],
        );
      },
    );
  }
}