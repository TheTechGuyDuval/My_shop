import 'package:flutter/material.dart';
import '../providers/orders.dart' show Orders;
import '../widget/app_drawer.dart';
import 'package:provider/provider.dart';

import '../widget/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(title: Text('Your Orders'),),
      body: ListView.builder(
        itemCount:orderData.orders.length ,
        itemBuilder:(ctx,index){
          return OrderItem(orderData.orders[index]);

        } ),
    );
  }
}