import 'package:e_commer/provider/cart.dart';
import 'package:e_commer/provider/products.dart';
import 'package:e_commer/screens/cart_screen.dart';
import 'package:e_commer/components/app_drawer.dart';
import 'package:e_commer/components/badge.dart';
import 'package:e_commer/widgets/circle_button_widget.dart';
import 'package:e_commer/widgets/circle_button_with_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_theme.dart';
import '../components/products_grid.dart';
import '../my_flutter_app_icons.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorites = false;
  bool _isLoading = false;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('MyShop'),
          actions: <Widget>[
            PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Favorites) {
                    _showOnlyFavorites = true;
                  } else {
                    _showOnlyFavorites = false;
                  }
                });
              },
              icon: Icon(
                Icons.more_vert,
              ),
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('Only Favorites'),
                  value: FilterOptions.Favorites,
                ),
                PopupMenuItem(
                  child: Text('Show All'),
                  value: FilterOptions.All,
                ),
              ],
            ),
            Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                child: ch,
                value: cart.itemCount.toString(),
              ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  Navigator.pushNamed(context, CartScreen.route);
                },
              ),
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Scaffold(
                backgroundColor: AppTheme.bgColor,
                body: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                "👋 Hi, Angle!",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                "What is your favorite sushi?",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            buildSearch(),
                            SizedBox(height: 12),
                            buildHeader("Categories", () {}),
                            SizedBox(height: 12),
                            buildCategories(),
                            SizedBox(height: 32),
                            buildHeader("Top Sushi", () {}),
                            SizedBox(height: 12),
                            SizedBox(
                              height: 300,
                              child: ProductsGrid(_showOnlyFavorites),
                            ),
                            SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ));
  }

  Widget buildHeader(String title, VoidCallback onSeeAllTap) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          InkWell(
            child: Text("See all"),
            onTap: onSeeAllTap,
          ),
        ],
      ),
    );
  }

  Widget buildSearch() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Search your sushi",
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }

  Widget buildCategories() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleButtonWithTitle(icon: MyFlutterApp.salmon, title: "Salmon"),
          CircleButtonWithTitle(icon: MyFlutterApp.caviar, title: "Caviar"),
          CircleButtonWithTitle(icon: MyFlutterApp.rice, title: "Rice"),
          CircleButtonWithTitle(icon: MyFlutterApp.tentacles, title: "Octopus"),
          CircleButtonWithTitle(icon: MyFlutterApp.prawn, title: "Shrimp"),
        ],
      ),
    );
  }
}
