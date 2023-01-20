import 'package:flutter/material.dart';
import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';
import '../widget/cart_item.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final order = Provider.of<Orders>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .titleLarge!
                              .color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(
                      onPressed: () {
                        order.addOrder(
                            cart.items.values.toList(), cart.totalAmount);
                        cart.clear();
                      },
                      child: Text(
                        'ORDER NOW',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ))
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: cart.itemCount,
                  itemBuilder: (context, index) {
                    return CartItem(
                        cart.items.values.toList()[index].id,
                        cart.items.keys.toList()[index],
                        cart.items.values.toList()[index].price,
                        cart.items.values.toList()[index].quantity,
                        cart.items.values.toList()[index].title);
                  }))
        ],
      ),
    );
  }
}
