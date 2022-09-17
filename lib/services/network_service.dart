import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkService {
  static Future<http.Response> getToken(
      String username, String password) async {
    return http.post(
      Uri.parse('https://ticketing.alexbordei.dev/wp-json/jwt-auth/v1/token'),
      body: json.encode({"username": username, "password": password}),
      headers: {"Content-Type": "application/json"},
    );
  }

  static Future<http.Response> validateToken(String token) async {
    return http.post(
      Uri.parse(
          'https://ticketing.alexbordei.dev/wp-json/jwt-auth/v1/token/validate'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
  }
}
