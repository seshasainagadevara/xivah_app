import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:xivah/constants/konstants.dart';
import 'package:xivah/crops/catalogProduct_data.dart';
import 'package:xivah/farmingNotifiers/qty_counter_notifier.dart';

import 'counter_bar.dart';

class CatalogListTile extends StatefulWidget {
  final CatalogProductData catalogProductData;
  CatalogListTile({
    this.catalogProductData,
  });

  @override
  _CatalogListTileState createState() => _CatalogListTileState();
}

extension str on String {
  num toNum() => num.tryParse(this.trim());
}

class _CatalogListTileState extends State<CatalogListTile> {
  CatalogProductData _data;
  QtyCounterNotifier _qtyCounterNotifier;
  num presentValue;
  num totalValue;

  @override
  void initState() {
    _data = widget.catalogProductData;
    _qtyCounterNotifier = QtyCounterNotifier.del(
        min: _data.minimum.toNum(),
        max: _data.maximum.toNum(),
        price: _data.price.toNum(),
        qty: _data.quantity.toNum(),
        measure: _data.measure,
        addedQuantity: _data.addedQuantity?.toNum(),
        addedTotal: _data.addedTotal?.toNum());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<QtyCounterNotifier>(
      create: (BuildContext context) => _qtyCounterNotifier,
      child: Card(
        borderOnForeground: false,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                dense: true,
                leading: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: _data.imageUrl,
                    height: 60.0,
                    width: 60.0,
                    imageScale: 3.0,
                    placeholderScale: 3.0,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                title: Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      text: _data.name,
                      style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                subtitle: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          text:
                              "Qty: ${_data.quantity} ${_data.measure}     Price: ₹${_data.price}",
                          style: TextStyle(
                              fontSize: 10.0,
                              color: Colors.black54,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Consumer<QtyCounterNotifier>(
                      builder: (context, value, _) {
                        if (value == null) return Konstants.nothing;
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            text: TextSpan(
                              text: "Total: ${value.total}/- ",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.0),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Consumer<QtyCounterNotifier>(
                    builder:
                        (BuildContext context, QtyCounterNotifier value, _) {
                      if (value != null) {
                        totalValue = value.total;
                        presentValue = value.presentValue;
                        return CounterBar(value);
                      } else
                        return Opacity(
                          opacity: 0.0,
                        );
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getCounterColumn(QtyCounterNotifier value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
            icon: Icon(
              Icons.add_circle,
              size: 18.0,
              color: Colors.green,
            ),
            onPressed: () => value.increment()),
        Container(
            width: 20.0,
            alignment: Alignment.center,
            child: Text(
              "${value.presentValue}",
              style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.w800,
                  fontSize: 12.0),
            )),
        IconButton(
            icon: Icon(
              Icons.remove_circle,
              color: Colors.green,
              size: 18.0,
            ),
            onPressed: () => value.decrement())
      ],
    );
  }
}
