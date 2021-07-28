import 'package:flutter/foundation.dart';

class QtyCounterNotifier extends ChangeNotifier {
  num presentValue = 0.0;
  num total = 0.0;
  num min;
  num max;
  num price;
  num qty;
  String measure;
  num addedTotal;
  num addedQuantity;

  QtyCounterNotifier.add({
    this.min,
    this.max,
    this.price,
    this.qty,
    this.measure,
  }) {
    presentValue = min;
    total = formula(presentValue, price, qty);
  }

  QtyCounterNotifier.del(
      {this.min,
      this.max,
      this.price,
      this.qty,
      this.measure,
      this.addedTotal,
      this.addedQuantity}) {
    presentValue = addedQuantity;
    total = addedTotal;
  }

  increment() async {
    if (presentValue < max) {
      switch (measure) {
        case "kg":
          presentValue = presentValue + 0.5;
          formula(presentValue, price, qty);
          break;
        case "piece":
          presentValue = presentValue + 1;
          formula(presentValue, price, qty);
          break;
        case "dozen":
          presentValue = presentValue + 0.5;
          formula(presentValue, price, qty);
          break;
      }
    }
  }

  decrement() async {
    if (presentValue > min) {
      switch (measure) {
        case "kg":
          presentValue = presentValue - 0.5;
          formula(presentValue, price, qty);
          break;
        case "piece":
          presentValue = presentValue - 1;
          formula(presentValue, price, qty);
          break;

        case "dozen":
          presentValue = presentValue - 0.5;
          formula(presentValue, price, qty);
          break;
      }
    }
  }

  formula(num present, num price, num qty) {
    presentValue = present;
    total = (presentValue * price) / qty;
    notify();
    return total;
  }

  notify() => notifyListeners();
}
