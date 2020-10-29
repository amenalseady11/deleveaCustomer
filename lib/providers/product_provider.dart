
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

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print(url);
      print(extractedData);

      if (extractedData == null || extractedData['responseCode']!=200) {
        return;
      }
      List<ProductModel> categories = [];
      categories = (extractedData['products'] as List)
          .map((i) => ProductModel.fromJson(i))
          .toList();
      _items = categories;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
