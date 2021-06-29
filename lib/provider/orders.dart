import 'package:flutter/cupertino.dart';
import './cart.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class OrdersItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrdersItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrdersItem> _orderItems = [];
  final String authToken;
  final String userId;
  Orders(
    this.authToken,
    this.userId,
    this._orderItems,
  );
  List<OrdersItem> get orderItems {
    return [..._orderItems];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://e-commerce-aff3c-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final List<OrdersItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    } //if fail will not excute code after that
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrdersItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                ),
              )
              .toList(),
        ),
      );
    });
    // _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  void addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        "https://e-commerce-aff3c-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken";
    try {
      final timeStamp = DateTime.now();
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': timeStamp.toIso8601String(),
            "products": cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'price': cp.price,
                    })
                .toList(),
          }));
      _orderItems.insert(
          0,
          OrdersItem(
              id: json.decode(response.body)['name'],
              amount: total,
              products: cartProducts,
              dateTime: DateTime.now()));
      // _items.insert(0, newProduct); // at start of the list
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }

    notifyListeners();
  }
}
