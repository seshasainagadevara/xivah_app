import 'package:cloud_firestore/cloud_firestore.dart';

abstract class CatalogProductDataEvent {}

class CatalogProductDataError extends CatalogProductDataEvent {
  CatalogProductDataError();
}

class CatalogProductData extends CatalogProductDataEvent {
  String documentID;
  String name;
  String pid;
  String imageUrl;
  String price;
  String quantity;
  bool availability;
  String minimum;
  String maximum;
  String measure;
  String addedQuantity;
  String addedTotal;
  String desc;

  CatalogProductData({
    this.name,
    this.pid,
    this.imageUrl,
    this.price,
    this.quantity,
    this.measure,
    this.minimum,
    this.maximum,
    this.availability,
    this.documentID,
    this.addedQuantity,
    this.addedTotal,
    this.desc,
  });

  factory CatalogProductData.fromDocumentSnapShot(
      DocumentSnapshot documentSnapshot) {
    dynamic data = documentSnapshot.data;
    return CatalogProductData(
        name: data["name"],
        pid: data["pid"],
        imageUrl: data["imageUrl"],
        price: data["price"],
        documentID: documentSnapshot.documentID,
        minimum: data["minimum"],
        maximum: data["maximum"],
        quantity: data["quantity"],
        addedQuantity: data["addedQuantity"] ?? '0',
        addedTotal: data["addedTotal"] ?? '0.0',
        measure: data["measure"],
        desc: data["desc"],
        availability: data["availability"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "name": this.name,
      "pid": this.pid,
      "imageUrl": this.imageUrl,
      "price": this.price,
      "minimum": this.minimum,
      "maximum": this.maximum,
      "quantity": this.quantity,
      "measure": this.measure,
      "availability": this.availability,
      "addedQuantity": this.addedQuantity,
      "addedTotal": this.addedTotal
    };
  }
}
