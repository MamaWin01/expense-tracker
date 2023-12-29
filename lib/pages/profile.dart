import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:expense_app/widget/main_page.dart';
import 'package:expense_app/Helper/constant.dart';
import 'package:expense_app/Helper/function.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  dynamic name = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    var prefs = await SharedPreferences.getInstance();
    var test = prefs?.getString('token');
    var jwtDecodedToken = JwtDecoder.decode(test.toString());
    if (mounted) {
      setState(() {
        name = "${jwtDecodedToken['name']}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w500,
            height: 0,
          ),
        ),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Main_page(
                  initialIndex: 0,
                ),
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            CircleAvatar(
              radius: 70,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('assets/images/Default_Image.png'),
            ),
            const SizedBox(width: 20.0),
            Text(
              name == null ? '' : name,
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 20.0),
            Card(
              color: Colors.white,
              child: ListTile(
                leading: const Icon(Icons.account_box_rounded),
                title: const Text('Edit Account'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pushNamed(context, '/edit_profile');
                },
                enableFeedback: false,
              ),
            ),
            const SizedBox(height: 10.0),
            Card(
              color: Colors.white,
              child: ListTile(
                leading: const Icon(Icons.account_balance),
                title: const Text('Bank Account Info'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pushNamed(context, '/bank_info');
                },
                enableFeedback: false,
              ),
            ),
            const SizedBox(height: 10.0),
            Card(
              color: Colors.white,
              child: ListTile(
                leading: const Icon(Icons.credit_card),
                title: const Text('E-Wallet Info'),
                trailing: const Icon(Icons.chevron_right),
                enableFeedback: false,
                onTap: () => {Navigator.pushNamed(context, '/ewallet_info')},
              ),
            )
          ],
        ),
      ),
    );
  }
}
