import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_riverpod_extended/providers/app_config_provider.dart';

class AuthRepository {
  final Reader read;

  AuthRepository({this.read});

  Future<void> login(String email, String password) async {
    final String baseUrl = read(appConfigProvider).state.baseUrl;
    final String buildFlavor = read(appConfigProvider).state.buildFlavor;

    final String url = '$baseUrl/login';

    await Future.delayed(Duration(seconds: 2));

    if (buildFlavor == 'dev') {
      print('EMAIL: $email, PASSWORD: $password');
    }

    final http.Response response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'email': email,
          'password': password,
        },
      ),
    );

    if (response.statusCode != 200) {
      if (buildFlavor == 'dev') {
        print('${response.statusCode}: ${response.reasonPhrase}');
      }
      throw Exception('Fail to login');
    }

    final responseBody = json.decode(response.body);
    final token = responseBody['token'];

    if (buildFlavor == 'dev') {
      print('token: $token');
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwtToken', token);
  }

  Future<bool> tryAutoLogin() async {
    await Future.delayed(Duration(seconds: 1));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('jwtToken');
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwtToken');
  }
}
