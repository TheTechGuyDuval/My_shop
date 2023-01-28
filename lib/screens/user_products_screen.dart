import 'package:flutter/material.dart';
import '../screens/edit_product_screen.dart';
import '../widget/app_drawer.dart';
import '../widget/user_product_ite..dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class userProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (context, productsData, _) =>Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                            itemCount: productsData.items.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  UserProductItem(
                                      productsData.items[index].id,
                                      productsData.items[index].title,
                                      productsData.items[index].imageUrl),
                                  Divider()
                                ],
                              );
                            }),
                      ),
                      
                    ),
                  ),
      ),
    );
  }
}
