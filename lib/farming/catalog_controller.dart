import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xivah/crops/catalogProduct_data.dart';

class CatalogController {
  Stream<List<CatalogProductData>> _catalogStream;
  Firestore _firestore;
  final String _collection;
  CatalogController(this._collection) {
    _firestore = Firestore.instance;
    _getCatalog();
  }

  _getCatalog() async {
    _catalogStream = _firestore
        .collection("services/market/products/$_collection/items")
        .snapshots()
        .map((snap) => snap.documents)
        .transform(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) => sink.add(data
                .map((doc) => CatalogProductData.fromDocumentSnapShot(doc))
                .toList()),
            handleError: (_, stackTrc, sink) =>
                sink.addError("Something went wrong ! Check internet"),
            handleDone: (EventSink sink) => sink.close(),
          ),
        );
  }

  Stream<List<CatalogProductData>> get catalogStream => _catalogStream;

  set catalogStream(Stream<List<CatalogProductData>> value) {
    _catalogStream = value;
  }
}
