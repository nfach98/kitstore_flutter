import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/core/config/constants.dart';
import 'package:store_app/core/config/globals.dart';
import 'package:store_app/layers/domain/entities/brand.dart';
import 'package:store_app/layers/presentation/main/notifier/catalogue_notifier.dart';
import 'package:store_app/layers/presentation/kit_store_button.dart';

import '../../kit_store_text_field.dart';

class BottomSheetFilter extends StatefulWidget {
  final List<Brand> brands;
  final List<Brand> selectedBrands;
  final List<String> sorts;
  final String selectedSort;
  final RangeValues priceRange;

  const BottomSheetFilter({Key key, this.brands, this.selectedBrands, this.priceRange, this.sorts, this.selectedSort}) : super(key: key);

  @override
  _BottomSheetFilterState createState() => _BottomSheetFilterState();
}

class _BottomSheetFilterState extends State<BottomSheetFilter> {
  List<Brand> selectedBrands;
  String selectedSort;

  TextEditingController _minPriceController;
  TextEditingController _maxPriceController;

  @override
  void initState() {
    super.initState();
    _minPriceController = TextEditingController();
    _maxPriceController = TextEditingController();

    if (widget.selectedBrands != null) {
      selectedBrands = widget.selectedBrands;
    }
    if (widget.priceRange != null) {
      _minPriceController.text = widget.priceRange.start == 0 ? "" : widget.priceRange.start.toInt().toString();
      _maxPriceController.text = widget.priceRange.end == double.maxFinite ? "" : widget.priceRange.end.toInt().toString();
    }
    if (widget.selectedSort != null) {
      selectedSort = widget.selectedSort;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            children: [
              Container(
                height: 8,
                alignment: Alignment.center,
                width: App.getWidth(context) * .5,
                decoration: BoxDecoration(
                  color: colorPrimary,
                  borderRadius: BorderRadius.circular(32)
                ),
              ),
              SizedBox(height: 20),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Filter",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 20),

                  Text(
                    "Brands",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  ChipsChoice<Brand>.multiple(
                    wrapped: true,
                    spinnerColor: colorPrimary,
                    value: selectedBrands,
                    onChanged: (val) {
                      setState(() {
                        selectedBrands = val;
                        context.read<CatalogueNotifier>().setSelectedBrand(val);
                      });
                    },
                    choiceAvatarBuilder: (item) {
                      return Container(
                        width: 24,
                        child: AspectRatio(
                            aspectRatio: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(100)),
                              child: Image.asset(
                                item == null
                                    ? "assets/images/no_image.png"
                                    : item.value.image,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )
                        ),
                      );
                    },
                    choiceItems: C2Choice.listFrom<Brand, Brand>(
                        source: widget.brands,
                        value: (i, v) => v,
                        label: (i, v) => v.name,
                        style: (id, brand) {
                          return C2ChoiceStyle(
                              borderColor: Colors.transparent
                          );
                        }
                    ),
                    choiceActiveStyle: C2ChoiceStyle(
                        color: colorPrimary,
                        showCheckmark: false,
                        borderColor: colorPrimary
                    ),
                  ),
                  SizedBox(height: 12),

                  Text(
                    "Price Range",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: KitStoreTextField(
                          controller: _minPriceController,
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          hintText: "Min",
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(12),
                            child: Text("Rp"),
                          ),
                          onChanged: (value) {
                            context.read<CatalogueNotifier>().setPriceRange(RangeValues(
                                value.isEmpty ? 0 : double.parse(value),
                                _maxPriceController.text.isEmpty ? double.maxFinite : double.parse(_maxPriceController.text)
                            ));
                          },
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: KitStoreTextField(
                          controller: _maxPriceController,
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          hintText: "Max",
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(12),
                            child: Text("Rp"),
                          ),
                          onChanged: (value) {
                            context.read<CatalogueNotifier>().setPriceRange(RangeValues(
                                _minPriceController.text.isEmpty ? 0 : double.parse(_minPriceController.text),
                                value.isEmpty ? double.maxFinite : double.parse(value)
                            ));
                          },
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: 36),
                  Text(
                    "Sort",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  ChipsChoice<String>.single(
                    wrapped: true,
                    spinnerColor: colorPrimary,
                    value: selectedSort,
                    onChanged: (val) {
                      setState(() {
                        selectedSort = val;
                        context.read<CatalogueNotifier>().setSort(val);
                      });
                    },
                    choiceItems: C2Choice.listFrom<String, String>(
                        source: widget.sorts,
                        value: (i, v) => v,
                        label: (i, v) {
                          if (v == "p.price DESC") return "Price: High to Low";
                          return "Price: Low to High";
                        },
                        style: (id, brand) {
                          return C2ChoiceStyle(
                              borderColor: Colors.transparent
                          );
                        }
                    ),
                    choiceActiveStyle: C2ChoiceStyle(
                        color: colorPrimary,
                        showCheckmark: false,
                        borderColor: colorPrimary
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
              FractionallySizedBox(
                widthFactor: 1,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    _minPriceController.clear();
                    _maxPriceController.clear();
                    context.read<CatalogueNotifier>().resetFilter();
                    context.read<CatalogueNotifier>().resetList();
                    context.read<CatalogueNotifier>().getProducts();
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Reset all",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colorPrimary
                      ),
                    ),
                  ),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 1,
                child: KitStoreButton(
                  text: "Apply filter",
                  onPressed: () {
                    Navigator.pop(context);
                    context.read<CatalogueNotifier>().resetList();
                    context.read<CatalogueNotifier>().getProducts();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
