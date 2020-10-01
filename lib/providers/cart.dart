import 'dart:convert';

import 'package:app/providers/cart_item_model.dart';
import 'package:app/providers/product_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class CartItem {
  final String id;
  final String title;
  final String itemUrl;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.itemUrl,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  var authToken;

  Cart(this.authToken);

  List<CartItemModel> _cartItems = [];
  Map<String, CartItem> _items = {};
  int _orderId;

  Map<String, CartItem> get items {
    return {..._items};
  }

  List<CartItemModel> get cartItems {
    return _cartItems;
  }

  int get orderId {
    return _orderId;
  }

  int get itemCount {
    return _cartItems.length;
  }

  double get totalAmount {
    var total = 0.0;
    _cartItems.forEach((cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  Future<void> fetchIncompleteOrderId(
      {String productId, String merchantId, int quantity}) async {
    var url = 'http://delevea.pythonanywhere.com/api/cart/order/';
    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $authToken',
      });
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      _orderId = extractedData['id'];

      print(extractedData);
      addToCartItems(_orderId, productId, merchantId, quantity);
    } catch (error) {
      throw (error);
    }
  }

  Future<void> updateCartItem(int orderId, String productId, String merchantId,
      int quantity, int orderItemId) async {
    var url =
        'http://delevea.pythonanywhere.com/api/order-item-update/id=$orderItemId';
    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Token $authToken',
          },
          body: json.encode({
            'product': productId,
            'order': orderId,
            'quantity': quantity,
            'merchant': merchantId,
          }));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      var status = extractedData['success'];

      print(extractedData);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addToCartItems(
      int orderId, String productId, String merchantId, int quantity) async {
    var url = 'http://delevea.pythonanywhere.com/api/order-item-create/';
    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Token $authToken',
          },
          body: json.encode({
            'product': productId,
            'order': orderId,
            'quantity': quantity,
            'merchant': merchantId,
          }));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      var status = extractedData['success'];

      print(extractedData);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchCartItems(bool listen) async {
    var url = 'http://delevea.pythonanywhere.com/api/cart/orderItems/';
    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $authToken',
      });
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      List<CartItemModel> cartData = [];
      List<ProductModel> productDetails = [];
      cartData = (extractedData['orderItems'] as List)
          .map((i) => CartItemModel.fromJson(i))
          .toList();
      productDetails = (extractedData['product_list'] as List)
          .map((i) => ProductModel.fromJson(i))
          .toList();
      if (cartData.length > 0) {
        productDetails.asMap().forEach((index, value) {
          cartData[index].title = value.title;
          cartData[index].price = value.price;
          cartData[index].image = value.image;
        });

        _cartItems = cartData;
        _orderId = _cartItems[0].order;
      } else
        _cartItems.clear();
      print(extractedData);

      if (listen) notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  void addItem(
    String productId,
    double price,
    String title,
    String itemUrl,
  ) {
    if (_items.containsKey(productId)) {
      // change quantity...
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          itemUrl: existingCartItem.itemUrl,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            price: price,
            quantity: 1,
            itemUrl: itemUrl),
      );
    }
    notifyListeners();
  }

  Future<void> removeItem(int productId) async {
    final url =
        'http://delevea.pythonanywhere.com/api/order-item-update/id=$productId/';
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $authToken',
      },
    );
    try {
      final data = json.decode(response.body) as Map<String, dynamic>;
    } catch (e) {}
    // ignore: unrelated_type_equality_checks
    cartItems.removeWhere((element) => element.id == productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                title: existingCartItem.title,
                price: existingCartItem.price,
                itemUrl: existingCartItem.itemUrl,
                quantity: existingCartItem.quantity - 1,
              ));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
