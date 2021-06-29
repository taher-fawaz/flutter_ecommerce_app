import 'package:e_commer/provider/orders.dart';
import 'package:e_commer/components/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart';
import '../components/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const route = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).accentColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) => CartSingleItem(
                cart.cartItem.keys.toList()[i],
                cart.cartItem.values.toList()[i].id,
                cart.cartItem.values.toList()[i].price,
                cart.cartItem.values.toList()[i].quantity,
                cart.cartItem.values.toList()[i].title,
              ),
              itemCount: cart.itemCount,
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              'Order now',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading == true)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart.cartItem.values.toList(),
                widget.cart.totalAmount,
              );
              setState(() {
                _isLoading = false;
              });
              widget.cart.clear();
            },
    );
  }
}
