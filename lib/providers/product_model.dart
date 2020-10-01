import 'dart:math';

import 'package:flutter/material.dart';

class ProductModel with ChangeNotifier {
  String id;
  String title;
  String description;
  String availability;
  String image;
  int category;
  String merchant;
  double price;
  String offerPrice;
  String discount;
  final Color color;

  ProductModel({
      this.id,
      this.title,
      this.description,
      this.availability,
      this.image,
      this.category,
      this.merchant,
      this.price,
      this.offerPrice,
      this.discount,this.color});

  factory ProductModel.fromJson(Map<String, dynamic> parsedJson) {
    var _list = [0xFFD3A984,0xFF989493,0xFFE6B398,0xFF3D82AE];
    return ProductModel(
      id: parsedJson['id'].toString(),
      price: (parsedJson['price']),
      merchant: (parsedJson['merchant']).toString(),
      offerPrice: (parsedJson['offerPrice']).toString(),
      discount: (parsedJson['discount']).toString(),
      title: parsedJson['name'].toString(),
      description: parsedJson['description'].toString(),
      category: parsedJson['category'],
      availability: parsedJson['availability'].toString(),
      image: parsedJson['image'].toString(),
      color:  Color(_list[Random().nextInt(_list.length)])

    );
  }
}