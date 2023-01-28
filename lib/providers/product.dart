import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.price,
      this.isFavorite = false});

  Future<void> toggleFavoriteStatus(String token, String userId,) async {
    final url = Uri.parse("https://my-shop-1c748-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token"
        );
    
    var oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      await http.put(url, body: jsonEncode({
        'isFavorite' : isFavorite
      }
      ));


    } catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
      throw error;
    }
    
  }
}
