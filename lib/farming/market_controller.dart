import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xivah/crops/catalogProduct_data.dart';
import 'package:xivah/crops/grid_tile_data.dart';

class MarketController {
  Firestore _firestore;
  Stream<List<GridTileData>> _gridTilesStream;
  String _uid;
  CollectionReference _colref;
  Stream<int> lengthStream;
  StreamSink<int> _streamSink;
  Stream<List<CatalogProductData>> cartStream;
  StreamController _cartStreamController =
      StreamController<List<CatalogProductData>>.broadcast();
  StreamSink<List<CatalogProductData>> _cartSink;
  StreamController _streamController = StreamController<int>.broadcast();
  // SharedPreferences _sharedPreferences;

  MarketController.getGridTile() {
    _firestore = Firestore.instance;
    _getProducts();
  }
  MarketController.getCartCount() {
    _firestore = Firestore.instance;
    _streamSink = _streamController.sink;
    lengthStream = _streamController.stream;
    _create().then((_) => _getCartCount());
  }
  MarketController.getkARTList() {
    _firestore = Firestore.instance;
    cartStream = _cartStreamController.stream;
    _cartSink = _cartStreamController.sink;
    _create().then((_) => _getKartList());
  }

  MarketController.updateCart() {
    _firestore = Firestore.instance;
    _create();
  }

  MarketController.getKart() {
    _firestore = Firestore.instance;
    _create();
  }
  Future<void> _create() async {
    await SharedPreferences.getInstance().then((value) {
      _uid = value.getStringList("creds")[3];
      _colref = _firestore.collection("users/$_uid/cart").reference();
    });
  }

  Future<bool> updateCart() {
    DocumentReference _docref;
    num today = DateTime.now().day;

    _colref.snapshots().map((event) => event.documents).forEach((element) {
      element.forEach((element) async {
        int day = DateTime.fromMillisecondsSinceEpoch(
                int.parse(element.documentID.trim()))
            .day;
        if (day != today) {
          _docref = _colref.document(element.documentID);
          await _firestore
              .runTransaction((transaction) => transaction.delete(_docref))
              .catchError((error) {
            print("error deleting updating cart $error");
          });
        }
      });
    });
  }

  void _getProducts() async {
    gridTilesStream = _firestore
        .collection("services/market/products")
        .snapshots()
        .map((snap) => snap.documents)
        .transform(StreamTransformer.fromHandlers(
          handleData: (data, sink) => sink.add(data
              .map((doc) => GridTileData.fromDocumentSnapShot(doc))
              .toList()),
          handleError: (_, stackTrc, sink) =>
              sink.addError([GridTileDataError()], stackTrc),
          handleDone: (EventSink sink) => sink.close(),
        ));
  }

  Future<void> writeCartItems(CatalogProductData _catalog) async {
    DocumentReference _docRf =
        _colref.document(DateTime.now().millisecondsSinceEpoch.toString());
    await _firestore.runTransaction((trasaction) async {
      await trasaction.set(_docRf, _catalog.toMap());
    }).catchError((error) {
      print("error caalog $error");
    });
  }

  _getKartList() async {
    _colref
        .snapshots()
        .map((snaps) => snaps.documents)
        .transform(StreamTransformer.fromHandlers(
          handleData: (data, sink) {
            return sink.add(data
                .map((doc) => CatalogProductData.fromDocumentSnapShot(doc))
                .toList());
          },
          handleError: (_, stackTrc, sink) =>
              sink.addError([CatalogProductDataError()], stackTrc),
          handleDone: (EventSink sink) => sink.close(),
        ))
        .listen(
      (data) {
        print(data);
        _cartSink.add(data);
      },
      onDone: () {
        _cartSink.close();
        _cartStreamController.close();
      },
      cancelOnError: false,
    );
  }

  Future<void> deleteCartItem(String docId) async {
    DocumentReference _docref = _colref.document(docId);
    await _firestore
        .runTransaction((transaction) => transaction.delete(_docref))
        .catchError((error) {
      print("error deleting $error");
    });
  }

  _getCartCount() async {
    _colref.snapshots().listen(
      (data) {
        _streamSink.add(data.documents.length);
      },
      onDone: () {
        _streamSink.close();
        _streamController.close();
      },
      cancelOnError: false,
    );
  }

  Stream<List<GridTileData>> get gridTilesStream => _gridTilesStream;

  set gridTilesStream(Stream<List<GridTileData>> value) {
    _gridTilesStream = value;
  }
}
