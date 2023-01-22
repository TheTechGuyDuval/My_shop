import 'package:flutter/material.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  var _form = GlobalKey<FormState>();
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  
  var _isInit = true;
  var _editedProduct =
      Product(id: '', title: '', description: '', imageUrl: '', price: 0);
    
  var _initValues ={
    'title' : '',
    'description' : '',
    'price' : '',
    'imageUrl' : '',

  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if(_isInit){
     final productId = ModalRoute.of(context)!.settings.arguments as dynamic;
     if(productId != null) {
       _editedProduct =  Provider.of<Products>(context,listen: false).findById(productId);
       _initValues = {
    'title' : _editedProduct.title,
    'description' :  _editedProduct.description,
    'price' :  _editedProduct.price.toString(),
    // 'imageUrl' :  _editedProduct.imageUrl,
     'imageUrl' : '',

    };
    _imageUrlController.text = _editedProduct.imageUrl;
     }
    
    
    }
    _isInit = false;

  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (
          (!_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpeg')) ||
          (!_imageUrlController.text.startsWith('http'))) {
            return;
          }
      setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if(!isValid){
      return;
    }
   
      _form.currentState!.save();
    if(_editedProduct.id != ''){

      Provider.of<Products>(context,listen: false).updateProduct(_editedProduct.id, _editedProduct);
    }else{
      Provider.of<Products>(context,listen: false).addProduct(_editedProduct);
    }
  
    Navigator.of(context).pop();
    
    
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initValues['title'],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Enter a title';
                  }

                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (newTitle) {
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      title: newTitle!,
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                      price: _editedProduct.price,
                      isFavorite: _editedProduct.isFavorite);
                },
              ),
              TextFormField(
                 initialValue: _initValues['price'],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Enter a Price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please Enter a valid number.';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please Enter a Number greater than Zero.';
                  }
                  return null;
                },
                focusNode: _priceFocusNode,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (newPrice) {
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite,
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                      price: double.parse(newPrice!));
                },
              ),
              TextFormField(
                 initialValue: _initValues['description'],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Enter a Description';
                  }

                  if (value.length < 10) {
                    return 'Please Enter atleast 10 characters.';
                  }
                  return null;
                },
                maxLines: 3,
                focusNode: _descriptionFocusNode,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                onSaved: (newDescription) {
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite,
                      title: _editedProduct.title,
                      description: newDescription!,
                      imageUrl: _editedProduct.imageUrl,
                      price: _editedProduct.price);
                },
              ),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(right: 10, top: 8),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey)),
                      child: _imageUrlController.text.isEmpty
                          ? Text(
                              'Enter a Url',
                            )
                          : FittedBox(
                              child: Image.network(_imageUrlController.text),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter an Image URL';
                          }
                    
                          if (!value.startsWith('http')) {
                            return 'Please Enter a valid URL.';
                          }
                          //  if(!value.endsWith('.jpg') && !value.endsWith('.png') && !value.endsWith('.jpeg') ){
                          //   return 'Please enter a valid image URL'
                          //  }
                          return null;
                        },
                        decoration: const InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        onSaved: (newUrl) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              imageUrl: newUrl!,
                              price: _editedProduct.price);
                        },
                      ),
                    )
                  ],
                ),
              
            ],
          ),
        ),
      ),
    );
  }
}
