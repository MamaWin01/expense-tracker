import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:expense_app/Helper/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

TextEditingController EmailController = TextEditingController();
TextEditingController PasswordController = TextEditingController();

void LoginAccount(context, prefs, String email, password) async {
  try {
    Response response = await post(Uri.parse('$API_URL/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'email': email, 'password': password}));

    if (response.statusCode == 200) {
      // showDialog(context: context, builder: (context) {
      //   return
      // })
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Login"),
                content: const Text("Login successfully"),
                actions: <Widget>[
                  InkWell(
                    onTap: () {
                      var myToken = jsonDecode(response.body)['token'];
                      prefs.setString('token', myToken);
                      Navigator.pushNamed(context, '/mainPage',
                          arguments: myToken);
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
                title: const Text("Login"),
                content: Text(
                    "Login Failed ${jsonDecode(response.body)['error'].toString()}"),
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

class _LoginState extends State<Login> {
  bool _obscureText = true;
  late SharedPreferences prefs;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  final bool _isNotValidate = false;

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
        body: Container(
            width: 414,
            height: 932,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(color: Color(0xFFFAFAFA)),
            child: Stack(
              children: [
                const Positioned(
                    left: 30,
                    top: 60,
                    child: SizedBox(
                      width: 330,
                      child: Text(
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
                    )),
                Positioned(
                    left: 33,
                    top: 200,
                    width: 330,
                    height: 50,
                    child: TextField(
                      controller: EmailController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0.50, color: Color(0xFF828282)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2.5, color: Color(0xFF31A062)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: "E-mail"),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    )),
                Positioned(
                    left: 33,
                    top: 260,
                    width: 330,
                    height: 50,
                    child: TextField(
                      controller: PasswordController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0.50, color: Color(0xFF828282)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2.5, color: Color(0xFF31A062)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: "Password"),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                      obscureText: _obscureText,
                    )),
                Positioned(
                  left: 315,
                  top: 273,
                  width: 330,
                  child: InkWell(
                    onTap: _toggle,
                    enableFeedback: false,
                    child: Text(_obscureText ? 'Show' : 'Hide'),
                  ),
                ),
                Positioned(
                    left: 38,
                    top: 450,
                    child: SizedBox(
                      width: 310,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF31A062),
                              enableFeedback: false),
                          onPressed: () {
                            LoginAccount(
                                context,
                                prefs,
                                EmailController.text.toString(),
                                PasswordController.text.toString());
                          },
                          child: const Text(
                            'Login',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          )),
                    )),
                Positioned(
                    left: 41,
                    top: 510,
                    child: SizedBox(
                      width: 310,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        enableFeedback: false,
                        child: const Text(
                          'Register',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF31A062),
                            fontSize: 17,
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                      ),
                    )),
              ],
            )));
  }
}
