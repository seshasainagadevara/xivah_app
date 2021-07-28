import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xivah/constants/konstants.dart';
import 'package:xivah/crops/catalogProduct_data.dart';
import 'package:xivah/farming/internet_connection_checker.dart';
import 'package:xivah/farming/market_controller.dart';
import 'package:xivah/farmingEvents/connection_status_data.dart';
import 'package:xivah/lands/subLands/catalog_tile.dart';
import 'package:xivah/lands/subLands/checkout_sheet.dart';
import 'package:xivah/lands/subLands/error_diag.dart';
import 'package:xivah/lands/subLands/internetConnectionWidget.dart';

class TheCart extends StatefulWidget {
  @override
  _TheCartState createState() => _TheCartState();
}

class _TheCartState extends State<TheCart> {
  MarketController _marketController;
  InternetChecker _internetChecker;
  @override
  void didUpdateWidget(TheCart oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _internetChecker = InternetChecker();
    _marketController = MarketController.getkARTList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<CatalogProductDataEvent>>(
      create: (BuildContext context) => _marketController.cartStream,
      catchError: (context, error) => error,
      child: Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          title: Text("Cart"),
          backgroundColor: Colors.transparent,
        ),
        bottomNavigationBar: Container(
          color: Colors.indigo[500],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                onTap: () async {
                  await showModalBottomSheet(
                      context: context, builder: (context) => CheckoutSheet());
                },
                title: Text(
                  "Shop now",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                leading: Icon(
                  Icons.shopping_basket,
                  color: Colors.white,
                ),
                trailing: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      topLeft: Radius.circular(20.0),
                    )),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
                margin: EdgeInsets.only(top: 10.0),
                child: Consumer<List<CatalogProductDataEvent>>(
                  builder: (BuildContext context,
                      List<CatalogProductDataEvent> value, _) {
                    if (value == null)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    if (value is List<CatalogProductData> && value.length == 0)
                      return Center(
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              border: Border.all(
                                width: 2.0,
                                color: Colors.black12,
                              )),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                Icons.child_care,
                                size: 50.0,
                                color: Colors.green,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text("No items in the cart !",
                                  style: TextStyle(
                                    color: Colors.black38,
                                    fontWeight: FontWeight.w700,
                                  )),
                            ],
                          ),
                        ),
                      );

                    if (value is List<CatalogProductDataError>)
                      return ErrorDiag();

                    if (value is List<CatalogProductData>)
                      return ListView.builder(
                        itemCount: value.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Dismissible(
                            background: _getBackground(true),
                            secondaryBackground: _getBackground(false),
                            key: Key(value[index].documentID),
                            onDismissed: (direction) {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => Container(
                                        height: 200.0,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "Hold on! removing item...",
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ));
                              _marketController
                                  .deleteCartItem(value[index].documentID)
                                  .then((value) => Navigator.pop(context));
                            },
                            child: CatalogListTile(
                              catalogProductData: value[index],
                            ),
                          );
                        },
                      );

                    return Konstants.nothing;
                  },
                ),
              ),
            ),
            StreamBuilder<InternetConnection>(
                stream: _internetChecker.stream,
                initialData: InternetConnectionSuccess(),
                builder: (context, snapshot) {
                  if (snapshot.data is InternetConnectionSuccess)
                    return Konstants.nothing;

                  if (snapshot.error is InternetConnectionError)
                    return InternetConnectionWidget();
                }),
          ],
        ),
      ),
    );
  }

  Widget _getBackground(bool pos) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        alignment: pos ? Alignment.centerLeft : Alignment.centerRight,
        padding:
            pos ? EdgeInsets.only(left: 10.0) : EdgeInsets.only(right: 10.0),
        color: Colors.red,
        child: Icon(
          Icons.delete_forever,
          color: Colors.white,
          size: 30.0,
        ),
      ),
    );
  }
}
