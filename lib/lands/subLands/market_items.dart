import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xivah/crops/grid_tile_data.dart';
import 'package:xivah/farming/market_controller.dart';

import 'ItemsGridTile.dart';
import 'error_diag.dart';

class MarketItems extends StatefulWidget {
  @override
  _MarketItemsState createState() => _MarketItemsState();
}

class _MarketItemsState extends State<MarketItems> {
  MarketController _marketController;
  @override
  void initState() {
    _marketController = MarketController.getGridTile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<GridTileDataEvent>>(
      create: (context) => _marketController.gridTilesStream,
      catchError: (context, error) => error,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Consumer<List<GridTileDataEvent>>(
          builder: (BuildContext context, value, _) {
            if (value is List<GridTileDataError>) return ErrorDiag();
            if (value is List<GridTileData>) {
              return GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: value.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return ItemsGridTile(tileData: value[index]);
                  });
            }
            return Center(child: Center(child: CircularProgressIndicator()));
          },
        ),
      ),
    );
  }
}
