import 'package:flutter/material.dart';

class UserData with ChangeNotifier {
  int id;
  String name;
  String email;
  String phone;
  int alternatePhone;
  String city;
  String state;
  String country;
  String postalAddress;
  String zipcode;
  String profilePic;
  String dateCreated;
  int user;

  UserData(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.alternatePhone,
      this.city,
      this.state,
      this.country,
      this.postalAddress,
      this.zipcode,
      this.profilePic,
      this.dateCreated,
      this.user});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    alternatePhone = json['alternate_phone'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    postalAddress = json['postal_address'];
    zipcode = json['zipcode'];
    profilePic = json['profile_pic'];
    dateCreated = json['date_created'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['alternate_phone'] = this.alternatePhone;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['postal_address'] = this.postalAddress;
    data['zipcode'] = this.zipcode;
    data['profile_pic'] = this.profilePic;
    data['date_created'] = this.dateCreated;
  data['user'] = this.user;
    return data;
  }
}
