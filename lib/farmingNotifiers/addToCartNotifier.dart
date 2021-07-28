import 'package:flutter/foundation.dart';
import 'package:xivah/crops/catalogProduct_data.dart';
import 'package:xivah/farming/market_controller.dart';

class AddToCartNotifier extends ChangeNotifier {
  MarketController _marketController;
  bool isAdded;
  AddToCartNotifier() {
    _marketController = MarketController.getKart();
  }

  updateCartNumber(CatalogProductData _catlogData) {
    isAdded = false;
    notifyListeners();
    _marketController.writeCartItems(_catlogData).then((_) {
      isAdded = true;
      notifyListeners();
    });
  }
}
