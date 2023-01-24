import 'package:flutter/material.dart';
import '../providers/products.dart';
import '../screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

   UserProductItem(this.id,this.title,this.imageUrl);

  @override
  Widget build(BuildContext context) {
  final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl,),
        
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(onPressed: (){
              Navigator.of(context).pushNamed(EditProductScreen.routeName,arguments: id);
            }, icon: Icon(Icons.edit,color: Theme.of(context).primaryColor)),
             IconButton(onPressed: () async {
              try{
               await Provider.of<Products>(context,listen: false).deleteProduct(id);
              }
              catch(error){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Deleting Failed!'))
                );

              }
              
             }, icon: Icon(Icons.delete,color: Theme.of(context).errorColor,))
          ],
        ),
      ),
    );
  }
}