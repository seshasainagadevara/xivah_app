import 'package:flutter/material.dart';
import 'package:xivah/farming/market_controller.dart';
import 'package:xivah/lands/theCart.dart';

class CartIcon extends StatefulWidget {
  @override
  _CartIconState createState() => _CartIconState();
}

class _CartIconState extends State<CartIcon> {
  MarketController _marketController;
  @override
  void initState() {
    _marketController = MarketController.getCartCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("cameee");
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: Alignment.topLeft,
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.shopping_cart), onPressed: () => _navigate()),
          Container(
            height: 20.0,
            width: 20.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: StreamBuilder(
              stream: _marketController.lengthStream,
              builder: (
                context,
                value,
              ) {
                if (!value.hasData)
                  return Text(
                    "0",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold),
                  );
                return Text(
                  "${value.data}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  _navigate() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) => TheCart()));
  }
}
