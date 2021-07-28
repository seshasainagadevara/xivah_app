import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:xivah/constants/konstants.dart';
import 'package:xivah/crops/market_corousel_data.dart';
import 'package:xivah/farming/market_corousel_controller.dart';

import '../catalouge_screen.dart';
import 'carousel_show.dart';
import 'error_diag.dart';

class MarketCarousel extends StatefulWidget {
  @override
  _MarketCarouselState createState() => _MarketCarouselState();
}

class _MarketCarouselState extends State<MarketCarousel> {
  MarketCorouselController _controller;

  @override
  void initState() {
    _controller = MarketCorouselController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<MarketCorouselDataEvent>>(
      create: (BuildContext context) => _controller.mCorouselStream,
      catchError: (ctx, event) => event,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.25,
        width: MediaQuery.of(context).size.width,
        child: Consumer<List<MarketCorouselDataEvent>>(
          builder: (context, data, _) {
            if (data is List<MarketCorouselDataError>) return ErrorDiag();
            if (data is List<MarketCorouselData>) {
              return CarouselShow(
                data,
                onTap: (index) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ProductCatalogScreen(product: data[index].type)));
                },
              );
            }
            return Konstants.nothing;
          },
        ),
      ),
    );
  }
}
