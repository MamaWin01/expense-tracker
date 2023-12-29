import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

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

getBankOrEWalletInfo(userInfo, type) async {
  try {
    Response response = await post(Uri.parse('$API_URL/getBankOrEWallet'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'email': userInfo['email'], 'type': type}));
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

class CurrencyInputFormatter extends TextInputFormatter {
  final validationRegex = RegExp(r'^[\d,]*\.?\d*$');
  final replaceRegex = RegExp(r'[^\d\.]+');
  static const fractionalDigits = 2;
  static const thousandSeparator = ',';
  static const decimalSeparator = '.';

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (!validationRegex.hasMatch(newValue.text)) {
      return oldValue;
    }

    final newValueNumber = newValue.text.replaceAll(replaceRegex, '');

    var formattedText = newValueNumber;

    /// Add thousand separators.
    var index = newValueNumber.contains(decimalSeparator)
        ? newValueNumber.indexOf(decimalSeparator)
        : newValueNumber.length;

    while (index > 0) {
      index -= 3;

      if (index > 0) {
        formattedText = formattedText.substring(0, index) +
            thousandSeparator +
            formattedText.substring(index, formattedText.length);
      }
    }

    /// Limit the number of decimal digits.
    final decimalIndex = formattedText.indexOf(decimalSeparator);
    var removedDecimalDigits = 0;

    if (decimalIndex != -1) {
      var decimalText = formattedText.substring(decimalIndex + 1);

      if (decimalText.isNotEmpty && decimalText.length > fractionalDigits) {
        removedDecimalDigits = decimalText.length - fractionalDigits;
        decimalText = decimalText.substring(0, fractionalDigits);
        formattedText = formattedText.substring(0, decimalIndex) +
            decimalSeparator +
            decimalText;
      }
    }

    /// Check whether the text is unmodified.
    if (oldValue.text == formattedText) {
      return oldValue;
    }

    /// Handle moving cursor.
    final initialNumberOfPrecedingSeparators =
        oldValue.text.characters.where((e) => e == thousandSeparator).length;
    final newNumberOfPrecedingSeparators =
        formattedText.characters.where((e) => e == thousandSeparator).length;
    final additionalOffset =
        newNumberOfPrecedingSeparators - initialNumberOfPrecedingSeparators;

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(
          offset: newValue.selection.baseOffset +
              additionalOffset -
              removedDecimalDigits),
    );
  }
}
