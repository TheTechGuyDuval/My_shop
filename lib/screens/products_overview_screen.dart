import 'package:flutter/material.dart';
import '../providers/products.dart';
import '../screens/cart_screen.dart';
import '../widget/app_drawer.dart';
import '../widget/product_grid.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../widget/badge.dart';


enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  bool _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    //  Future.delayed(Duration.zero).then((value){
    //   Provider.of<Products>(context).fetchAndSetProducts();
    //  });
    // // TODO: implement initState
    super.initState();
  }


  @override
  void didChangeDependencies() {
    if(_isInit){
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_){
     setState(() {
       _isLoading = false;
     });
      });

    }
    _isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) => {
                    if (selectedValue == FilterOptions.Favorites)
                      {
                        setState(() {
                          _showOnlyFavorites = true;
                        })
                      }
                    else
                      {
                        setState(() {
                          _showOnlyFavorites = false;
                        })
                      }
                  },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Only Favorites'),
                      value: FilterOptions.Favorites,
                    ),
                    PopupMenuItem(
                      child: Text('show All'),
                      value: FilterOptions.All,
                    )
                  ]),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch!,
              value: cart.itemCount.toString(),
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      body:_isLoading ? Center(child: CircularProgressIndicator()) : ProductsGrid(_showOnlyFavorites),
      drawer: AppDrawer(),
    );
  }
}
