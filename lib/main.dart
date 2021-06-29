import 'package:e_commer/provider/auth.dart';
import 'package:e_commer/provider/cart.dart';
import 'package:e_commer/provider/products.dart';
import 'package:e_commer/screens/auth_screen.dart';
import 'package:e_commer/screens/cart_screen.dart';

import 'package:e_commer/screens/products_overview_screens.dart';
import 'package:e_commer/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/orders.dart';
import 'screens/edit_product_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/product_details_screen.dart';
import 'screens/user_products_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          builder: (ctx, auth, previousProducts) => Products(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.items),
        ),
        ChangeNotifierProvider(
          builder: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          builder: (ctx, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.orderItems,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          title: 'Flutter Demo',
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                  future: auth.tryAutoLogin(),
                ),
          routes: {
            ProductDetailScreen.route: (context) => ProductDetailScreen(),
            CartScreen.route: (context) => CartScreen(),
            OrdersScreen.route: (context) => OrdersScreen(),
            UserProductsScreen.route: (context) => UserProductsScreen(),
            EditProductScreen.route: (context) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
