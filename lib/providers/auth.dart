import 'dart:async';
import 'dart:convert';

import 'package:app/models/user_data.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;
  UserData _userData;

  UserData get userData => _userData;
  bool get isAuth {
    return token != null;
  }

  String get token {
    return _token;
  }

  String get userId {
    return _userId;
  }

  Future<bool> signupUser(
      String userName, String password, String email) async {
    final url = 'http://delevea.pythonanywhere.com/auth/users/';
    print(url);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: json.encode(
          {
            'username': userName,
            'email': email,
            'password': password,
            're_password': password,
          },
        ),
      );
      print(json.decode(response.body));

      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (responseData['id'] == null) {
        if(responseData['password']!=null)
        throw HttpException('password',101);
        else if(responseData['username']!=null)
          throw HttpException('username',102);
        else if(responseData['email']!=null)
          throw HttpException('email',103);
      }
      notifyListeners();
      return true;
    } catch (error) {
      throw error;
    }
  }

  Future<bool> _authenticate(
      String userName, String password) async {
    final url = 'http://delevea.pythonanywhere.com/auth/token/login/';
    print(url);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: json.encode(
          {
            'username': userName,
            'password': password,
          },
        ),
      );
      print(json.decode(response.body));

      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (responseData['auth_token'] == null) {
        throw HttpException("Authentication Failed",100);
      }
      _token = responseData['auth_token'];
      notifyListeners();
      getUserDetails();
      return true;
    } catch (error) {
      throw error;
    }
  }

  Future<void> getUserDetails() async {
    final url = 'http://delevea.pythonanywhere.com/api/customer-get/';
    print(url);
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Token $_token',
        },
      );
      print(json.decode(response.body));

      final responseData =   UserData.fromJson(json.decode(response.body));
      if (responseData.id == null) {
        throw HttpException("Authentication Failed",100);
      }
      _userData = responseData;
      _userId = _userData.id.toString();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userName': _userData.name,
          'userId': _userId,
        },
      );
      prefs.setString(USER_DATA, userData);
    } catch (error) {
      throw error;
    }
  }


  Future<bool> login(String email, String password) async {
    return _authenticate(email, password);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(USER_DATA)) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString(USER_DATA)) as Map<String, Object>;
    /*   final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }*/
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    if (_token == null) return false;

    notifyListeners();
    // _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }

    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(USER_DATA);
    prefs.clear();
  }

/* void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }*/
}
