import 'dart:convert';
import 'dart:async';

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

class _RegisterState extends State<Register> {
  bool _obscureText = true;
  bool ispress = false;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

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
            builder: (context) {
              return const AlertDialog(
                title: Text("Account Creation"),
                backgroundColor: Colors.white,
                content: Text(
                    "Account have been created successfully, Redirecting one moment..."),
              );
            });
        Timer(const Duration(seconds: 1), () {
          Navigator.pushNamed(context, '/login');
        });
      } else {
        setState(() {
          ispress = false;
        });
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text("Account Creation"),
                  content: Text(jsonDecode(response.body)['error'].toString()),
                  backgroundColor: const Color(0xFFFAFAFA),
                  actions: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          ispress = false;
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
        // resizeToAvoidBottomInset: false,

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
                    const SizedBox(
                      height: 0,
                    ),
                    const Text(
                      'Create an account',
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
                      textAlign: TextAlign.justify,
                      controller: FullnameController,
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
                        labelText: "Full name",
                      ),
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
                                CreateAccount(
                                    context,
                                    FullnameController.text.toString(),
                                    EmailController.text.toString(),
                                    PasswordController.text.toString());
                              },
                        child: Text(
                          ispress ? 'Processing...' : 'Create account',
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
                        Navigator.pushNamed(context, '/login');
                      },
                      enableFeedback: false,
                      child: const Text(
                        'Already Have an account?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF31A062),
                          fontSize: 14,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ));
  }
}
