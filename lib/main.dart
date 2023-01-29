import 'package:flutter/material.dart';
import 'package:my_shop/helpers/custom_route.dart';
import '../providers/auth.dart';
import '../screens/auth_screen.dart';
import '../screens/splash_screen.dart';
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
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, auth, previousPdt) => Products(auth.token,
                previousPdt == null ? [] : previousPdt.items, auth.userId),
            // update: (context, value, previous) => ,
            create: (ctx) => Products('', [], '')),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
            update: (cxt, auth, previousOrders) => Orders(
                auth.token,
                previousOrders == null ? [] : previousOrders.orders,
                auth.userId),
            create: (context) => Orders('', [], '')),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'My_Shop',
          theme: ThemeData(
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android : CustomPageTransitionBuilder() ,
                TargetPlatform.iOS : CustomPageTransitionBuilder()
              }
            ),
              textTheme: TextTheme(
                  titleLarge: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.white)),
              fontFamily: 'Lato',
              primarySwatch: Colors.purple,
              colorScheme: ColorScheme.light(
                  primary: Colors.purple, secondary: Colors.deepOrange)),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
          routes: {
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrdersScreen.routeName: (context) => OrdersScreen(),
            userProductsScreen.routeName: (context) => userProductsScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
