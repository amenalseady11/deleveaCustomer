import 'dart:math';

import 'package:flutter/material.dart';

class ShopModel with ChangeNotifier {
  int id;
  int merchant;
  String name;
  String category;
  String description;
  String landmark;
  String city;
  String image;
  String zipcodes;
  bool isSelected;
  List<int> products;
  final Color color;
  int rate;
  String latitude;
  String longitude;
  ShopModel(
      {this.id,
      this.merchant,
      this.image,
      this.category,
      this.zipcodes,
      this.name,
      this.description,
      this.isSelected = false,
      this.products,
      this.landmark,
      this.latitude,
      this.longitude,
      this.city,
      this.color,
      this.rate});

  factory ShopModel.fromJson(Map<String, dynamic> parsedJson) {
    var _list = [0xFFD3A984, 0xFF989493, 0xFFE6B398, 0xFF3D82AE];

    return ShopModel(
        rate: 4,
        id: (parsedJson['id']),
        merchant: (parsedJson['merchant']),
        name: parsedJson['name'].toString(),
        image: parsedJson['image'].toString(),
        landmark: parsedJson['landmark'].toString(),
        city: parsedJson['city'].toString(),
        category: parsedJson['category'].toString(),
        longitude: parsedJson['longitude'].toString(),
        latitude: parsedJson['latitude'].toString(),
        zipcodes: parsedJson['zipcodes'].toString(),
        description: parsedJson['description'].toString(),
        color: Color(_list[Random().nextInt(_list.length)]));
  }
}
