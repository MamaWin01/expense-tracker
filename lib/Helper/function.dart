import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:expense_app/widget/main_page.dart';
import 'package:expense_app/Helper/constant.dart';
import 'package:http/http.dart';

void deleteToken() async {
  late SharedPreferences prefs;
  prefs = await SharedPreferences.getInstance();
  prefs.remove('token');
}

userData(userInfo) async {
  try {
    Response response = await post(Uri.parse('$API_URL/MainPage'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'email': userInfo['email']}));
    return jsonDecode(response.body);
  } catch (err) {
    debugPrint(err.toString());
  }
}

transactionData(userInfo, reqDate, status, type) async {
  try {
    Response response = await post(Uri.parse('$API_URL/getTransaction'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'email': userInfo['email'],
          'date_created': reqDate,
          'status': status,
          'type': type
        }));

    return jsonDecode(response.body);
  } catch (err) {
    debugPrint(err.toString());
  }
}

changeScreen(int index) async {
  late SharedPreferences prefs;
  prefs = await SharedPreferences.getInstance();
  prefs.setString('current_screen', index.toString());
}
