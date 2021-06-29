import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _cartItem = {};
  Map<String, CartItem> get cartItem {
    return {..._cartItem};
  }

  int get itemCount {
    return _cartItem.length;
  }

  double get totalAmount {
    double _total = 0.0;
    _cartItem.forEach((key, cartItem) {
      _total += cartItem.price * cartItem.quantity;
    });
    return _total;
  }

  addCartItem(String productId, double price, String title) {
    if (cartItem.containsKey(productId)) {
      //update quantity
      _cartItem.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity + 1,
          price: existingCartItem.price,
        ),
      );
    } else {
      //change quantity
      _cartItem.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                quantity: 1,
                price: price,
              ));
    }
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_cartItem.containsKey(productId)) {
      return;
    }
    if (_cartItem[productId].quantity > 1) {
      _cartItem.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity - 1,
          price: existingCartItem.price,
        ),
      );
    } else {
      _cartItem.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _cartItem = {};
    notifyListeners();
  }
}
