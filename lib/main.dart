import 'package:flutter/material.dart';
import '../screens/edit_product_screen.dart';
import '../screens/user_products_screen.dart';
import '../providers/cart.dart';
import '../providers/orders.dart';
import '../providers/products.dart';
import '../screens/cart_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/products_overview_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
       ChangeNotifierProvider(create: (context) => Products() ),
       ChangeNotifierProvider(create: (context) => Cart() ),
       ChangeNotifierProvider(create: (context) => Orders() ),

       ],

      
      child: MaterialApp(
        title: 'My_Shop',
        theme: ThemeData(
          fontFamily: 'Lato',
          primarySwatch: Colors.purple,
          colorScheme: ColorScheme.light(
            primary: Colors.purple,
            secondary: Colors.deepOrange
          )
        ),
        home:ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName :(context) => ProductDetailScreen(),
          CartScreen.routeName:(context) => CartScreen(),
          OrdersScreen.routeName:(context) => OrdersScreen(),
          userProductsScreen.routeName :(context) => userProductsScreen(),
          EditProductScreen.routeName:(context) => EditProductScreen(),
        },
      ),
    );
  }
}
