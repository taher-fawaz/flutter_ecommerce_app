import 'package:e_commer/provider/cart.dart';
import 'package:e_commer/provider/products.dart';
import 'package:e_commer/widgets/circle_button_widget.dart';
import 'package:e_commer/widgets/circle_button_with_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_theme.dart';
import '../my_flutter_app_icons.dart';

class ProductDetailScreen extends StatefulWidget {
  // final String title;
  // final double price;

  // ProductDetailScreen(this.title, this.price);
  static const route = '/product-detail';

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);

    final productId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    Offset _location;
    int priceSelectedIndex;

    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      body: Column(
        children: [
          SizedBox(height: 27),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 12, left: 12),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: CircleButtonWidget(
                    child: Icon(Icons.arrow_back_ios),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 12, right: 12),
                child: CircleButtonWidget(
                  child: Icon(Icons.favorite),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            "${loadedProduct.title}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
          SizedBox(height: 12),
          Text("${loadedProduct.description}"),
          SizedBox(height: 12),
          SizedBox(
            width: MediaQuery.of(context).size.width * .6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleButtonWithTitle(
                  icon: MyFlutterApp.salmon,
                  title: "Salmon",
                ),
                CircleButtonWithTitle(
                  icon: MyFlutterApp.caviar,
                  title: "Caviar",
                ),
                CircleButtonWithTitle(
                  icon: MyFlutterApp.rice,
                  title: "Rice",
                ),
              ],
            ),
          ),
          Image.network(
            loadedProduct.imageUrl,
            fit: BoxFit.cover,
            // height: 200,
          ),
          SizedBox(height: 24),
          Text("Choose the quality:"),
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    onPressed: () {},
                    padding: EdgeInsets.symmetric(vertical: 16),
                    color: AppTheme.darkColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      ),
                    ),
                    child: Text(
                      "Add to Cart",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// Scaffold(
//   appBar: AppBar(
//     title: Text(loadedProduct.title),
//   ),
//   body: SingleChildScrollView(
//     child: Column(
//       children: <Widget>[
//         Container(
//           height: 300,
//           width: double.infinity,
//           child: Image.network(
//             loadedProduct.imageUrl,
//             fit: BoxFit.cover,
//           ),
//         ),
//         SizedBox(height: 10),
//         Text(
//           '\$${loadedProduct.price}',
//           style: TextStyle(
//             color: Colors.grey,
//             fontSize: 20,
//           ),
//         ),
//         SizedBox(
//           height: 10,
//         ),
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 10),
//           width: double.infinity,
//           child: Text(
//             loadedProduct.description,
//             textAlign: TextAlign.center,
//             softWrap: true,
//           ),
//         )
//       ],
//     ),
//   ),
// );
