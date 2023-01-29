import 'package:flutter/material.dart';
import 'package:my_shop/helpers/custom_route.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';
import '../screens/user_products_screen.dart';
import '../screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(title: Text('Hello Friend'),automaticallyImplyLeading: false,),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
           Divider(),
           ListTile(
            leading: Icon(Icons.shop),
            title: Text('Orders'),
            onTap: () {
              // Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
              Navigator.of(context).pushReplacement(CustomRoute(builder: (ctx) => OrdersScreen()));
            },
          ),
          Divider(),
           ListTile(
            leading: const Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(userProductsScreen.routeName);
            },
          ),
           Divider(),
           ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: Text('Log Out'),
            onTap: () {
              Navigator.of(context).pop();   
               Navigator.of(context).pushReplacementNamed('/');
               Provider.of<Auth>(context,listen: false).logOut();
              
            },
          )
    
        ],
      ),
    );
  }
}