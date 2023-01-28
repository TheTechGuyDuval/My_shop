import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';


class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return token != '';
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token!;
    }
    return '';
  }

  String get userId {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _userId != null) {
      return _userId!;
    }
    return '';
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    Uri url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyC1YiGp1DMmjaRbCVZQdrJ7kpOOVmPGGgI');
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      // print(jsonDecode(response.body));
      final responseData = jsonDecode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoLogout();
      notifyListeners();

      final prefs =  await SharedPreferences.getInstance();
      final userData = jsonEncode({
        'token' : _token,
        'userId': _userId,
        'expiryDate' : _expiryDate!.toIso8601String()
         });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs =  await SharedPreferences.getInstance();
    
    if(!prefs.containsKey('userData')){
      return false;
    }
    final extractedUserData =jsonDecode(prefs.getString('userData')!) as Map<String , dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if(!expiryDate.isAfter(DateTime.now())){
      return false;
    }
    _token = extractedUserData['token'];
    _expiryDate = extractedUserData['expiryDate'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    
    notifyListeners();
    _autoLogout();
    return true;


  }

  Future<void> logOut() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    //_expiry date here Doesn't have a getter or nor is it
    // called from anywhere hence it can be null without a crash
    
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
      //  print(_authTimer.toString());
    }
    notifyListeners();
    final prefs =  await SharedPreferences.getInstance();
    prefs.remove('userData');
    // prefs.clear();

  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    // print(_authTimer.toString());
    _authTimer = Timer(Duration(seconds: timeToExpiry), logOut);
  }
}
