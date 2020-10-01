import 'package:flutter/material.dart';

class CartItemModel with ChangeNotifier {
  int id;
  int quantity;
  String dateAdded;
  String image;
  String title;
  double price;
  int product;
  int order;
  int merchant;

  CartItemModel(
      {this.id,
      this.quantity,
      this.dateAdded,
      this.product,
      this.order,
      this.merchant});

  factory CartItemModel.fromJson(Map<String, dynamic> parsedJson) {
    return CartItemModel(
      id: parsedJson['id'],
      quantity: parsedJson['quantity'],
      dateAdded: parsedJson['date_added'],
      product: parsedJson['product'],
      order: parsedJson['order'],
      merchant: parsedJson['merchant'],
    );
  }
}
