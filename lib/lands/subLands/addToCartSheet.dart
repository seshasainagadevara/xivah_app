import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:xivah/constants/konstants.dart';
import 'package:xivah/crops/catalogProduct_data.dart';
import 'package:xivah/farmingNotifiers/addToCartNotifier.dart';
import 'package:xivah/farmingNotifiers/qty_counter_notifier.dart';

import 'counter_bar.dart';

class AddToCartBottomSheet extends StatefulWidget {
  final CatalogProductData productData;
  AddToCartBottomSheet(this.productData);
  @override
  _AddToCartBottomSheetState createState() => _AddToCartBottomSheetState();
}

extension str on String {
  num toNum() => num.tryParse(this.trim());
}

class _AddToCartBottomSheetState extends State<AddToCartBottomSheet> {
  CatalogProductData _item;
  QtyCounterNotifier _qtyCounterNotifier;
  AddToCartNotifier _addToCartNotifier;

  @override
  void initState() {
    _item = widget.productData;
    _qtyCounterNotifier = QtyCounterNotifier.add(
      min: _item.minimum.toNum(),
      max: _item.maximum.toNum(),
      price: _item.price.toNum(),
      qty: _item.quantity.toNum(),
      measure: _item.measure,
    );
    _addToCartNotifier = AddToCartNotifier();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => _qtyCounterNotifier,
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => _addToCartNotifier,
        ),
      ],
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        height: (MediaQuery.of(context).size.height / 2.0) + 100.0,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150.0,
                    margin: EdgeInsets.only(top: 20.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: _item.imageUrl,
                        imageScale: 3.0,
                        placeholderScale: 3.0,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        text: _item.name,
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w900,
                            fontSize: 16.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          text: "${_item.quantity} ${_item.measure}",
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w800,
                              fontSize: 14.0),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        text: "₹ ${_item.price}",
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w800,
                            fontSize: 14.0),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 40.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          text: _item.desc,
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: 13.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.black12, width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              margin: EdgeInsets.only(bottom: 20.0),
              padding: EdgeInsets.all(8.0),
              child: Stack(children: <Widget>[
                Consumer<QtyCounterNotifier>(
                  builder: (context, value, _) {
                    if (value == null) return Konstants.nothing;

                    return Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CounterBar(value),
                        Container(
                          child: Align(
                            alignment: Alignment.center,
                            child: RichText(
                              text: TextSpan(
                                text:
                                    "Total: ${value.total}/- ", //${value.total}
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14.0),
                              ),
                            ),
                          ),
                        ),
                        RaisedButton(
                          onPressed: () {
                            _item.addedTotal = value?.total?.toString();
                            _item.addedQuantity =
                                value?.presentValue?.toString();
                            _addToCartNotifier.updateCartNumber(_item);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0))),
                          textColor: Colors.white,
                          color: Colors.redAccent[200],
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Add to cart ",
                                style: TextStyle(fontSize: 14.0),
                              ),
                              Icon(
                                Icons.add_shopping_cart,
                                size: 20.0,
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
                Consumer<AddToCartNotifier>(
                  builder: (BuildContext context, AddToCartNotifier value, _) {
                    if (value != null) {
                      switch (value.isAdded) {
                        case false:
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                  backgroundColor: Colors.red,
                                ),
                              ),
                            ),
                          );
                          break;
                        case true:
                          return FutureBuilder(
                            future: Future.delayed(
                                Duration(seconds: 2), () => true),
                            builder: (context, data) {
                              return !data.hasData
                                  ? Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0)),
                                        ),
                                        child: Center(
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Added to cart !",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.w900),
                                              )),
                                        ),
                                      ),
                                    )
                                  : Konstants.nothing;
                            },
                          );
                          break;
                      }
                    }
                    return Konstants.nothing;
                  },
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}
