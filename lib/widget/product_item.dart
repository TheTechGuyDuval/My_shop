import 'package:flutter/material.dart';
import '../providers/product.dart';
import '../screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  ProductItem();

  @override
  Widget build(BuildContext context) {
    final prodItem = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                  arguments: prodItem.id);
            },
            child: Image.network(
              prodItem.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black38,
            title: Text(
              prodItem.title,
              textAlign: TextAlign.center,
            ),
            leading: Consumer<Product>(
              builder: (ctx, prodItem, _) => IconButton(
                onPressed: () {
                  prodItem.toggleFavoriteStatus();
                },
                icon: Icon(prodItem.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            trailing: IconButton(
              onPressed: () {
                cart.addItem(prodItem.id, prodItem.price, prodItem.title);
              },
              icon: Icon(Icons.shopping_cart),
              color: Theme.of(context).colorScheme.secondary,
            ),
          )),
    );
  }
}
