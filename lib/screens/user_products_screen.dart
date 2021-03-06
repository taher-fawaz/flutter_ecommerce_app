import 'package:e_commer/provider/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/user_product_item.dart';
import '../components/app_drawer.dart';
import 'edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const route = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.route);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (ctx, productsData, _) => ListView.builder(
                        itemCount: productsData.items.length,
                        itemBuilder: (_, index) => UserProductItem(
                          productsData.items[index].id,
                          productsData.items[index].title,
                          productsData.items[index].imageUrl,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
