import 'package:flutter/material.dart';

class Sign_in extends StatelessWidget {
  const Sign_in({super.key});

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
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
        child: Text("Page is not available."),
      ),
    );
  }
}
