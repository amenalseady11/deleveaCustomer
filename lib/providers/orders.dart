import 'dart:convert';

import 'package:app/models/order_data.dart';
import 'package:app/providers/product_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart.dart';


class Orders with ChangeNotifier {
  final String authToken;
  final String userId;
  int _orderCount = 0;
  List<OrderData> _pastOrders = [];

  List<OrderData> get pastOrders => _pastOrders;

  int get orderCount => _orderCount;
  Orders(this.authToken, this.userId, this._pastOrders);



  Future<void> fetchPastOrders() async {
    var url = 'https://delevea.pythonanywhere.com/api/customer/orders/';
    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $authToken',
      });
      print(url);
      print(authToken);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      print(extractedData);
      _orderCount = int.parse(extractedData['count']);
      if (_orderCount > 0) {
        List<OrderData> orders = [];
        List<ProductModel> productDetails = [];
        productDetails = (extractedData['products'] as List)
            .map((i) => ProductModel.fromJson(i))
            .toList();
        orders = (extractedData['orderItems'] as List)
            .map((e) => new OrderData.fromJson(e))
            .toList();
        productDetails.asMap().forEach((index, value) {
          orders[index].image = value.image;
          orders[index].title = value.title;
          orders[index].price = value.price;
        });
        _pastOrders = orders;
      }
    } catch (error) {
      throw (error);
    }
  }
  Future<void> createShippingAddress(String address, int orderId) async {
    final url =
        'http://delevea.pythonanywhere.com/api/shipping-address-create/';
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $authToken',
      },
      body: json.encode({
        'customer': userId,
        'order': orderId,
        'address': address,
        'city': 'Pathanamthitta',
        'state': 'Kerala',
        'zipcode': '68524',
      }),
    );
    try {
      final data = json.decode(response.body) as Map<String, dynamic>;
      updateOrder(orderId);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateOrder(int orderId) async {
    final url =
        'http://delevea.pythonanywhere.com/api/order-update/id=$orderId/';
    final timestamp = DateTime.now();
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $authToken',
      },
      body: json.encode({
        'complete': true,
        'transaction_id': timestamp.toIso8601String(),
      }),
    );
    try {
      final data = json.decode(response.body) as Map<String, dynamic>;
    } catch (e) {}
    notifyListeners();
  }

/*  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        'https://flutter-update.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timestamp,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }*/
}
