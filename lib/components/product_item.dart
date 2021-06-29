import 'package:e_commer/models/color.dart';
import 'package:e_commer/provider/auth.dart';
import 'package:e_commer/provider/cart.dart';
import 'package:e_commer/provider/product.dart';
import 'package:e_commer/screens/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_theme.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    bool flag = true;
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          ProductDetailScreen.route,
          arguments: product.id,
        );
      },
      child: Container(
        width: 200,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          color: flag ? AppTheme.darkColor : Colors.white,
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),

                // Image.asset("assets/${list[index].image}"),
                Expanded(child: SizedBox.shrink()),
                Text(
                  "${product.title}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: !flag ? AppTheme.darkColor : Colors.white,
                  ),
                ),
                Text(
                  "${product.description}",
                  style: TextStyle(
                    color: !flag
                        ? AppTheme.darkColor.withAlpha(100)
                        : Colors.white.withAlpha(100),
                  ),
                ),
                Row(
                  children: [
                    Text.rich(
                      TextSpan(text: "\$", children: [
                        TextSpan(
                          text: "${product.price}",
                          style: TextStyle(fontSize: 24),
                        ),
                      ]),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: !flag ? AppTheme.darkColor : Colors.white,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: TextButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                !flag
                                    ? AppTheme.darkColor
                                    : Colors.white.withAlpha(100)),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ))),
                        onPressed: () {
                          cart.addCartItem(
                              product.id, product.price, product.title);
                          Scaffold.of(context).hideCurrentSnackBar();
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("Added Item To  Cart"),
                            duration: Duration(seconds: 2),
                            action: SnackBarAction(
                                label: "UNDO",
                                onPressed: () {
                                  cart.removeSingleItem(product.id);
                                }),
                          ));
                        },
                        child: Text(
                          "Order",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
    // ClipRRect(
    //   borderRadius: BorderRadius.circular(10),
    //   child: GridTile(
    //     child: GestureDetector(
    //       onTap: () {
    // Navigator.of(context).pushNamed(
    //   ProductDetailScreen.route,
    //   arguments: product.id,
    // );
    //       },
    //       child: Image.network(
    //         product.imageUrl,
    //         fit: BoxFit.cover,
    //       ),
    //     ),
    //     footer: GridTileBar(
    //       backgroundColor: Colors.black87,
    //       leading: Consumer<Product>(
    //         builder: (ctx, product, _) => IconButton(
    //           icon: Icon(
    //             product.isFavourite ? Icons.favorite : Icons.favorite_border,
    //           ),
    //           color: Theme.of(context).accentColor,
    //           onPressed: () {
    //             product.toggleFavoriteStatus(
    //               authData.token,
    //               authData.userId,
    //             );
    //           },
    //         ),
    //       ),
    //       title: Text(
    //         product.title,
    //         textAlign: TextAlign.center,
    //       ),
    //       trailing: IconButton(
    //         icon: Icon(
    //           Icons.shopping_cart,
    //         ),
    //         onPressed: () {
    // cart.addCartItem(product.id, product.price, product.title);
    // Scaffold.of(context).hideCurrentSnackBar();
    // Scaffold.of(context).showSnackBar(SnackBar(
    //   content: Text("Added Item To  Cart"),
    //   duration: Duration(seconds: 2),
    //   action: SnackBarAction(
    //       label: "UNDO",
    //       onPressed: () {
    //         cart.removeSingleItem(product.id);
    //       }),
    // ));
    //         },
    //         color: Theme.of(context).accentColor,
    //       ),
    //     ),
    //   ),
    // );
  }
}
