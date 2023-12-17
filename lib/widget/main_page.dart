import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:expense_app/pages/home.dart';
import 'package:expense_app/Helper/constant.dart';

class Main_page extends StatefulWidget {
  final token;
  const Main_page({this.token, super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<Main_page> {
  late String name;
  int _selectedIndex = 0;
  late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
  }

  deleteToken() async {
    prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }

  static const List<Widget> _NavbarOption = <Widget>[
    Home(),
    Text(
      'Index 1: Business',
    ),
    Text(
      'Index 2: School',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            child: const Icon(
              Icons.menu,
              color: Colors.black,
            ),
            onTap: () {
              deleteToken();
              Navigator.pushNamed(context, '/');
            },
          ),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    size: 26.0,
                  ),
                )),
          ],
        ),
        body: _NavbarOption.elementAt(_selectedIndex),
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
          onTap: _onItemTapped,
        ));
  }
}
