import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:expense_app/pages/home.dart';
import 'package:expense_app/pages/transaction.dart';
import 'package:expense_app/pages/profile.dart';
import 'package:expense_app/Helper/constant.dart';

class Main_page extends StatefulWidget {
  final token;
  final int initialIndex;
  const Main_page({this.token, required this.initialIndex, Key? key})
      : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<Main_page> with TickerProviderStateMixin {
  late String name;
  int _selectedIndex = 0;
  late SharedPreferences prefs;
  late AnimationController controller;
  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  deleteToken() async {
    prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: _pageController,
          children: [Home(), Transaction(), Profile()],
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.payments),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.manage_accounts),
              label: 'Account',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFF31A062),
          onTap: (index) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          enableFeedback: false,
        ));
  }
}
