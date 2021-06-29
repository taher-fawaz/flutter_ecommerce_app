import 'package:e_commer/provider/orders.dart';
import 'package:e_commer/components/order_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const route = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // bool _isLoading = false;
  @override
  void initState() {
    // Future.delayed(Duration.zero).then((_) async {
    //   setState(() {
    //     _isLoading = true;
    //   });
    //   await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
    //   setState(() {
    //     _isLoading = false;
    //   });
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context, listen: false);
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Previous orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error == null) {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemBuilder: (context, index) =>
                      OrderSingleItem(orderData.orderItems[index]),
                  itemCount: orderData.orderItems.length,
                ),
              );
            } else {
              return Center(
                child: Text('An error occured'),
              );
            }
          }
        },
      ),
    );
  }
}
