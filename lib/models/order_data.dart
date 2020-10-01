import 'package:flutter/material.dart';

class OrderData  with ChangeNotifier{
  int id;
  int quantity;
  String dateAdded;
  String title;
  String image;
  double price;
  int orderStatus;
  int product;
  int order;
  int merchant;

  OrderData(
      {this.id,
        this.quantity,
        this.dateAdded,
        this.orderStatus,
        this.product,
        this.order,
        this.merchant});

  OrderData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    dateAdded = json['date_added'];
    orderStatus = json['order_status'];
    product = json['product'];
    order = json['order'];
    merchant = json['merchant'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quantity'] = this.quantity;
    data['date_added'] = this.dateAdded;
    data['order_status'] = this.orderStatus;
    data['product'] = this.product;
    data['order'] = this.order;
    data['merchant'] = this.merchant;
    return data;
  }
}