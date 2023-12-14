import 'package:flutter/material.dart';

class First_page extends StatefulWidget {
  const First_page({super.key});

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<First_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: 414,
            height: 932,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(color: Color(0xFFFAFAFA)),
            child: Padding(
                padding: const EdgeInsets.only(top: 160, right: 30, left: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset('assets/icon/icon.png', width: 145),
                    ),
                    const SizedBox(height: 100),
                    const Text(
                      'Keep a track with your finance',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 34,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Text(
                        'We help you keep track of your personal expenses to accommodate your budget',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF4F4F4F),
                          fontSize: 17,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF31A062),
                            fixedSize: const Size(300, 30),
                            enableFeedback: false),
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: const Text(
                          'Login',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w900,
                            height: 0,
                          ),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      enableFeedback: false,
                      child: const Text(
                        'Create Account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF31A062),
                          fontSize: 17,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w900,
                          height: 0,
                        ),
                      ),
                    ),
                  ],
                ))));
  }
}
