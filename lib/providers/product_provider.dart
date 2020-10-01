
import 'package:app/providers/product_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductProvider with ChangeNotifier {
  List<ProductModel> _items = [];
  final String authToken;
  final String userId;

  List<ProductModel> get items {
    return [..._items];
  }

  ProductProvider(this.authToken, this.userId, this._items);

  Future<void> fetchProducts(String shopId) async {
    _items.clear();
    var url = 'https://delevea.pythonanywhere.com/api/products/shop=$shopId';
    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $authToken',
      });
      final extractedData = json.decode(response.body) as List<dynamic>;
      if (extractedData == null) {
        return;
      }
      List<ProductModel> categories = [];
      categories =
          (extractedData).map((e) => new ProductModel.fromJson(e)).toList();
      _items = categories;
      print(extractedData);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
