import 'package:cloud_firestore/cloud_firestore.dart';

abstract class GridTileDataEvent {}

class GridTileDataError extends GridTileDataEvent {
  GridTileDataError();
}

class GridTileData extends GridTileDataEvent {
  final String name;
  final String imageUrl;

  GridTileData(this.name, this.imageUrl);
  factory GridTileData.fromDocumentSnapShot(DocumentSnapshot documentSnapshot) {
    return GridTileData(
      documentSnapshot.documentID,
      documentSnapshot.data["imageUrl"],
    );
  }
}
