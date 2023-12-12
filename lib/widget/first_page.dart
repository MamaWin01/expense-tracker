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
      child: Stack(children: [
        Positioned(
          left: 30,
          top: 135,
          child: SizedBox(
            width: 330,
            child: Image.asset('assets/icon/icon.png'),
          ),
        ),
        const Positioned(
          left: 30,
          top: 456,
          child: SizedBox(
            width: 330,
            child: Text(
              'Keep a track with your financea',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 34,
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w700,
                height: 0,
                shadows: [
                  Shadow(
                    color: Colors.grey, // Choose the color of the second shadow
                    blurRadius:
                        20.0, // Adjust the blur radius for the second shadow effect
                    offset: Offset(0.0,
                        6.0), // Set the horizontal and vertical offset for the second shadow
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 30,
          top: 550,
          child: SizedBox(
            width: 310,
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
        ),
        Positioned(
            left: 30,
            top: 640,
            child: SizedBox(
              width: 310,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF31A062),
                      enableFeedback: false),
                  onPressed: () {
                    Navigator.pushNamed(context, '/sign_in');
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
            )),
        Positioned(
            left: 30,
            top: 695,
            child: SizedBox(
              width: 310,
              child: InkWell(
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
            )),
      ]),
    ));
  }
}
