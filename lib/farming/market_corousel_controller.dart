import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xivah/crops/market_corousel_data.dart';

class MarketCorouselController {
  Firestore _firestore;
  Stream<List<MarketCorouselData>> _mCorouselStream;

//corousel fetching
  MarketCorouselController() {
    _firestore = Firestore.instance;
    _getCoruselData();
  }

  void _getCoruselData() async {
    mCorouselStream = _firestore
        .collection("xivah/client/TopScrollAd/")
        .snapshots()
        .map((snap) => snap.documents)
        .transform(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) => sink.add(data
                .map((doc) => MarketCorouselData.fromDocumentSnap(doc))
                .toList()),
            handleError: (_, stackTrc, sink) =>
                sink.addError([MarketCorouselDataError()], stackTrc),
          ),
        );
  }

  set mCorouselStream(Stream<List<MarketCorouselData>> value) {
    _mCorouselStream = value;
  }

  Stream<List<MarketCorouselData>> get mCorouselStream => _mCorouselStream;
}
