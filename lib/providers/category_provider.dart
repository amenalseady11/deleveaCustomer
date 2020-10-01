import 'dart:convert';

import 'package:app/providers/ShopModel.dart';
import 'package:app/providers/category.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';
import '../models/http_exception.dart';

class ProductCategory with ChangeNotifier {
  List<CategoryModel> _items = [];
  List<ShopModel> _shopList = [];
  List<ShopModel> _searchShopList = [];

  List<ShopModel> get searchShopList => _searchShopList;

  final String authToken;
  final String userId;

  ProductCategory(this.authToken, this.userId, this._items);

  List<CategoryModel> get items {
    return [..._items];
  }

  List<ShopModel> get shopsList {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._shopList];
  }

/*  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }
*/


  Future<void> fetchCategories() async {
    var url = 'http://delevea.pythonanywhere.com/api/shop-category/all/';
    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $authToken',
      });
      if(response.statusCode ==200) {
        final extractedData = json.decode(response.body) as List<dynamic>;
        if (extractedData == null) {
          return;
        }
        List<CategoryModel> categories = [];
        categories =
            (extractedData).map((e) => new CategoryModel.fromJson(e)).toList();
        _items = categories;
        //  _items[0].isSelected = true;
        print(extractedData);
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> searchShops(String keyword) async {
    var url = 'https://delevea.pythonanywhere.com/api/products/search=' +
        keyword +
        '/';

    print(url);
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
      List<ShopModel> shops = [];
      shops = (extractedData['shops'] as List)
          .map((i) => ShopModel.fromJson(i))
          .toList();

      _searchShopList = shops;
      print(extractedData);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchCategoryShops(int catId) async {
    var url = 'http://delevea.pythonanywhere.com/api/shop-category=' +
        catId.toString();
    print(url);
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
      List<ShopModel> categories = [];
      categories =
          (extractedData).map((e) => new ShopModel.fromJson(e)).toList();
      _shopList = categories;
      print(extractedData);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {}

  Future<void> updateProduct(String id, Product newProduct) async {}

  Future<void> deleteProduct(String id) async {
    final url =
        'https://flutter-update.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.', 105);
    }
    existingProduct = null;
  }
}
