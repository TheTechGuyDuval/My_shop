import 'package:flutter/material.dart';
import '../providers/orders.dart' show Orders;
import '../widget/app_drawer.dart';
import 'package:provider/provider.dart';

import '../widget/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

Future? _ordersFuture;

Future _obtainedFuture(){
  return Provider.of<Orders>(context,listen: false).fetchAndSetOrders();
}
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ordersFuture = _obtainedFuture();
  }


  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(title: Text('Your Orders'),),
      body: FutureBuilder(future: _ordersFuture,
        builder: (ctx,snapshot){
       if(snapshot.connectionState == ConnectionState.waiting ){
       return Center(child: CircularProgressIndicator());
       }
       else{
        if(snapshot.hasError){
          // handle error
          return Center(child: Text('An Error Ocurred!'),);
        }
        else{
       return Consumer<Orders>(
         builder: (ctx, orderData, _) =>
         ListView.builder(
          itemCount:orderData.orders.length ,
          itemBuilder:(ctx,index){
            return OrderItem(orderData.orders[index]);
       
          } ),);
        }
       }

      })
    );
  }
}