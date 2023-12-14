import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:expense_app/Helper/constant.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

TextEditingController FullnameController = TextEditingController();
TextEditingController EmailController = TextEditingController();
TextEditingController PasswordController = TextEditingController();

void CreateAccount(context, String fullname, email, password) async {
  try {
    Response response = await post(Uri.parse('$API_URL/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            {'name': fullname, 'email': email, 'password': password}));

    if (response.statusCode == 200) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Account Creation"),
                content: const Text("Account have been created successfully"),
                actions: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    enableFeedback: false,
                    child: const Text('Ok'),
                  )
                ],
              ));
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Account Creation"),
                content: Text(
                    'Account Failed ${jsonDecode(response.body)['error'].toString()}'),
                backgroundColor: const Color(0xFFFAFAFA),
                actions: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    enableFeedback: false,
                    child: const Text('Go back'),
                  )
                ],
              ));
    }
  } catch (exp) {
    debugPrint(exp.toString());
  }
}

class _RegisterState extends State<Register> {
  bool _obscureText = true;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
          ),
        ),
        body: Container(
            width: 414,
            height: 932,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(color: Color(0xFFFAFAFA)),
            child: const Padding(
              padding: EdgeInsets.only(top: 160, right: 30, left: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [],
              ),
            )));
  }
}
