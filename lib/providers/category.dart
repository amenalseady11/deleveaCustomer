import 'package:flutter/material.dart';

class CategoryModel with ChangeNotifier {
  int id;
  String title;
  String description;
  bool isSelected;


  CategoryModel({this.id, this.title, this.description,this.isSelected = false});

  factory CategoryModel.fromJson(Map<String, dynamic> parsedJson) {
    return CategoryModel(
      id: (parsedJson['id']),
      title: parsedJson['category_name'].toString(),
      description: parsedJson['description'].toString(),
    );
  }
}