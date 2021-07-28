import 'package:cloud_firestore/cloud_firestore.dart';

abstract class MarketCorouselDataEvent {}

class MarketCorouselDataError extends MarketCorouselDataEvent {
  MarketCorouselDataError();
}

class MarketCorouselData extends MarketCorouselDataEvent {
  final String imageUrl;
  final String type;

  MarketCorouselData({
    this.imageUrl,
    this.type,
  });

  factory MarketCorouselData.fromDocumentSnap(
      DocumentSnapshot documentSnapshot) {
    return MarketCorouselData(
        imageUrl: documentSnapshot.data["image"],
        type: documentSnapshot.data["type"]);
  }
}
