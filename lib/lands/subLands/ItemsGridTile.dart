import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:xivah/crops/grid_tile_data.dart';

import '../catalouge_screen.dart';

class ItemsGridTile extends StatefulWidget {
  final dynamic tileData;

  const ItemsGridTile({this.tileData});

  @override
  _ItemsGridTileState createState() => _ItemsGridTileState();
}

class _ItemsGridTileState extends State<ItemsGridTile> {
  GridTileData _data;
  @override
  void initState() {
    _data = widget.tileData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductCatalogScreen(product: _data.name),
          ),
        );
      },
      child: GridTile(
        child: Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: _data.imageUrl,
//                                  imageScale: 3.0,
//                                  placeholderScale: 3.0,
              height: 150,
              width: 160,
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
        footer: Container(
          decoration: BoxDecoration(
            color: Colors.green[700],
          ),
          padding: EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          child: Text(
            _data.name,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 12.0),
          ),
        ),
      ),
    );
  }
}
