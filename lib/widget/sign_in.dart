import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:expense_app/Helper/constant.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

TextEditingController EmailController = TextEditingController();
TextEditingController PasswordController = TextEditingController();

class _LoginState extends State<Login> {
  bool _obscureText = true;
  int count = 0;
  bool ispress = false;
  late SharedPreferences prefs;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void LoginAccount(context, prefs, String email, password) async {
    try {
      Response response = await post(Uri.parse('$API_URL/login'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({'email': email, 'password': password}));

      if (response.statusCode == 200) {
        showDialog(
            // barrierDismissible: false,
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Login"),
                backgroundColor: Colors.white,
                content: Text("Login successfully, Redirecting one moment"),
              );
            });
        Timer(const Duration(seconds: 1), () {
          print('runnnnn');
          var myToken = jsonDecode(response.body)['token'];
          prefs.setString('token', myToken);
          count = 0;
          Navigator.pushNamed(context, '/mainPage', arguments: myToken);
        });
      } else {
        setState(() {
          ispress = false;
        });
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text("Login"),
                  content: Text(
                      "Login Failed ${jsonDecode(response.body)['error'].toString()}"),
                  backgroundColor: const Color(0xFFFAFAFA),
                  actions: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          EmailController.text = '';
                          PasswordController.text = '';
                        });
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

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    initSharedPref();
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
        body: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Container(
                width: 414,
                height: 932,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(color: Color(0xFFFAFAFA)),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 10,
                      right: 30,
                      left: 30,
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Login',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                      const SizedBox(
                        height: 120,
                      ),
                      TextField(
                        controller: EmailController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 0.50, color: Color(0xFF828282)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 2.5, color: Color(0xFF31A062)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: "E-mail"),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w400,
                          height: 1,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: PasswordController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0.50, color: Color(0xFF828282)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2.5, color: Color(0xFF31A062)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: "Password",
                          suffixIcon: IconButton(
                            icon: Icon(_obscureText
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: _toggle,
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w400,
                          height: 1,
                        ),
                        obscureText: _obscureText,
                      ),
                      const SizedBox(
                        // height: MediaQuery.of(context).viewInsets.bottom == 0
                        //     ? 80
                        //     : 10,
                        height: 80,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF31A062),
                              fixedSize: const Size(300, 30),
                              enableFeedback: false),
                          onPressed: ispress
                              ? null
                              : () {
                                  setState(() {
                                    ispress = true;
                                  });
                                  LoginAccount(
                                      context,
                                      prefs,
                                      EmailController.text.toString(),
                                      PasswordController.text.toString());
                                },
                          child: Text(
                            ispress ? 'Processing...' : 'Login',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          enableFeedback: false,
                          child: const Text(
                            'Register',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF31A062),
                              fontSize: 15,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          )),
                    ],
                  ),
                ))));
  }
}
