import 'package:flutter/foundation.dart';
import '../providers/cart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;


  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  
  List<OrderItem> _orders = [];
final String authToken;
final String userId;
  Orders(this.authToken,this._orders,this.userId);


  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse("https://my-shop-1c748-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken"
        );
    final response = await http.get(url);
    List<OrderItem> _loadedOrderItems = [];
    final extractedResponseData =
        jsonDecode(response.body) as  dynamic;
    if(extractedResponseData == null){
      return;
    }
    extractedResponseData.forEach((orderId, orderData) {
      _loadedOrderItems.add(OrderItem(
          id: orderId, amount: orderData['amount'],
           dateTime:DateTime.parse( orderData['dateTime']),
           products: (orderData['products'] as List<dynamic>).map((item) =>
            CartItem(id: item['id'], title: item['title'], quantity: item['quantity'], price: item['price'])).toList()
            ));
    });
    _orders = _loadedOrderItems.reversed.toList();
     notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
   final url = Uri.parse("https://my-shop-1c748-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken"
        );
    final timeStamp = DateTime.now();
    final response = await http.post(url,
        body: jsonEncode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((cartItem) => {
                    'id': cartItem.id,
                    'title': cartItem.title,
                    'quantity': cartItem.quantity,
                    'price': cartItem.price,
                  })
              .toList()
        }));
    _orders.insert(
        0,
        OrderItem(
            id: jsonDecode((response.body))['name'],
            amount: total,
            products: cartProducts,
            dateTime: timeStamp));
    notifyListeners();
  }
}
