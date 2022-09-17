import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_alexbordei_dev/services/network_service.dart';

import '../models/token.dart';

class AuthenticationProvider with ChangeNotifier {
  bool _isUserAuthenticated = false;
  bool _isLoading = true;

  bool get isUserAuthenticated => _isUserAuthenticated;
  bool get isLoading => _isLoading;

  Future<void> checkIfUserAuthenticated() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await NetworkService.validateToken(token);
        if (response.statusCode == 200) {
          _isUserAuthenticated = true;
          print('authenticated');
        } else {
          print(response.statusCode);
        }
      } on Exception catch (_, e) {}
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> login(
      String username, String password, showSnackbar, successRoute) async {
    _isLoading = true;
    notifyListeners();

    final response = await NetworkService.getToken(username, password);

    if (response.statusCode == 200) {
      Token token = Token.fromJson(
        jsonDecode(response.body),
      );
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token.token!);
      _isUserAuthenticated = true;
      successRoute();
    } else {
      showSnackbar();
    }

    _isLoading = false;
    notifyListeners();
  }
}
