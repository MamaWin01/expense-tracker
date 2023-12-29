import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart';
import 'package:expense_app/widget/subwidget/ewallet_info.dart';
import 'package:expense_app/Helper/constant.dart';
import 'package:expense_app/Helper/function.dart';

class AddEWallet extends StatefulWidget {
  const AddEWallet({super.key});

  @override
  _AddEWalletState createState() => _AddEWalletState();
}

TextEditingController NameController = TextEditingController();
TextEditingController AmountController = TextEditingController();

class _AddEWalletState extends State<AddEWallet> {
  bool ispress = false;
  late SharedPreferences prefs;

  AddEWalletInfo(context, prefs) async {
    var infoname = NameController.text.toString();
    var amount = AmountController.text.toString();
    var userData = JwtDecoder.decode(prefs.getString('token'));
    if (amount != '') {
      amount = amount.replaceAll(RegExp(r"\D"), "");
    } else {
      amount = '0';
    }
    try {
      Response response = await post(Uri.parse('$API_URL/addBankOrEWallet'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'type': 1,
            'name': infoname,
            'email': userData['email'],
            'amount': int.parse(amount),
          }));

      if (response.statusCode == 200) {
        showDialog(
            // barrierDismissible: false,
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("EWallet Account"),
                backgroundColor: Colors.white,
                content: Text("EWallet Account added successfully"),
              );
            });
        Timer(const Duration(seconds: 1), () {
          Navigator.pushNamed(context, '/ewallet_info');
        });
      } else {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text("EWallet Account"),
                  content: Text(
                      "EWallet Account Failed, ${jsonDecode(response.body)['error'].toString()}"),
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
      setState(() {
        ispress = false;
      });
    } catch (exp) {
      debugPrint(exp.toString());
    }
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        NameController.text = '';
        AmountController.text = '';
      });
    }
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
        title: const Text(
          'Add EWallet Account',
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
                builder: (context) => const EWalletInfo(),
              ),
            );
          },
        ),
      ),
      body: Container(
        width: 414,
        height: 932,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 10,
            right: 30,
            left: 30,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                textAlign: TextAlign.justify,
                controller: NameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 0.50, color: Color(0xFF828282)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 2.5, color: Color(0xFF31A062)),
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
                controller: AmountController,
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
                inputFormatters: [
                  // FilteringTextInputFormatter.digitsOnly,
                  CurrencyInputFormatter()
                ],
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 0.50, color: Color(0xFF828282)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 2.5, color: Color(0xFF31A062)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: "Amount",
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
                height: 40,
              ),
              ElevatedButton(
                onPressed: ispress
                    ? null
                    : () {
                        setState(() {
                          ispress = true;
                        });
                        AddEWalletInfo(context, prefs);
                      },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF31A062),
                    fixedSize: const Size(300, 30),
                    enableFeedback: false),
                child: Text(
                  ispress ? 'Processing...' : 'Add EWallet Info',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
