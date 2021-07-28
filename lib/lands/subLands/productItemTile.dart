import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:xivah/crops/catalogProduct_data.dart';
import 'package:xivah/lands/subLands/addToCartSheet.dart';

class ProductItemGridTile extends StatelessWidget {
  final CatalogProductData item;
  ProductItemGridTile(this.item);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: item.imageUrl,
                imageScale: 3.0,
                placeholderScale: 3.0,
                fit: BoxFit.scaleDown,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: RichText(
                      text: TextSpan(
                        text: item.name,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16.0),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: RichText(
                          text: TextSpan(
                            text: "₹ ${item.price}",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 16.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: RichText(
                                text: TextSpan(
                                  text: "${item.quantity} ${item.measure}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14.0),
                                ),
                              ),
                            ),
                          ),
                          FlatButton(
                            color: Colors.cyan,
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "ADD",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                                Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20.0,
                                )
                              ],
                            ),
                            onPressed: () async {
                              await showModalBottomSheet(
                                builder: (BuildContext context) =>
                                    AddToCartBottomSheet(item),
                                context: context,
                              );
                            },
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
