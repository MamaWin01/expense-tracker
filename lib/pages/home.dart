import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:expense_app/Helper/constant.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  dynamic name = 'loading...';
  bool ispress = false;
  dynamic balance = 0;
  dynamic ewallet = 0;
  dynamic transaction = [];
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    var prefs = await SharedPreferences.getInstance();
    var test = prefs?.getString('token');
    var jwtDecodedToken = JwtDecoder.decode(test.toString());
    var data = await userData(jwtDecodedToken);
    NumberFormat currencyFormatter = NumberFormat('###,###');
    if (mounted) {
      setState(() {
        name = "Welcome, ${jwtDecodedToken['name']}";
        balance = currencyFormatter.format(data['userBal']);
        ewallet = currencyFormatter.format(data['ewallet']);
        ispress = false;
        transaction = data['transaction'];
      });
    }
  }

  deleteToken() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }

  Widget build(BuildContext context) {
    return Scaffold(
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 34,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: 354,
                  height: 100,
                  decoration: ShapeDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment(-1.00, -0.01),
                      end: Alignment(1, 0.01),
                      colors: [Color(0xFFF0C735), Color(0xFFD98F39)],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          '\$',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 70,
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w500,
                            height: 1,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        height: 125,
                        child: Column(children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Text(
                              'Your total balance',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 25),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                balance == null
                                    ? 'loading...'
                                    : balance.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontFamily: 'DM Sans',
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                ),
                              ),
                            ),
                          )
                        ]),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  child: Row(children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        'E-Wallet',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w700,
                          height: 0.06,
                          letterSpacing: 0.80,
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 150),
                            child: Text(
                              'See All',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Color(0xFFFE555D),
                                fontSize: 18,
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w500,
                                height: 0.09,
                                letterSpacing: 0.80,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_right_alt_outlined,
                            size: 24.0,
                            color: Color(0xFFFE555D),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/e-wallet');
                      },
                    )
                  ]),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: 354,
                  height: 100,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment(-0.42, -0.91),
                      end: Alignment(0.42, 0.91),
                      colors: [Color(0xFF00A5CF), Color(0xFF004E64)],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Image.asset('assets/icon/wallet_icon.png',
                              width: 50)),
                      SizedBox(
                        width: 200,
                        height: 125,
                        child: Column(children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Text(
                              'Your total balance',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  ewallet == null
                                      ? 'loading...'
                                      : ewallet.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontFamily: 'DM Sans',
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                  ),
                                ),
                              ))
                        ]),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF31A062),
                        fixedSize: const Size(300, 30),
                        enableFeedback: false),
                    onPressed: () {
                      ispress
                          ? null
                          : Navigator.pushNamed(context, '/addTransaction');
                    },
                    child: const Text(
                      'Add new transaction',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    )),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 354,
                  height: 180,
                  child: Column(children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 175),
                      child: Text(
                        'Recent History',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w600,
                          height: 0.06,
                          letterSpacing: 0.80,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: transaction.length == 0
                          ? const Text('getting data...')
                          : Expanded(
                              child: SizedBox(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: transaction == null
                                    ? 0
                                    : transaction.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 150,
                                            child: Column(children: [
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10, left: 7),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      'Rp ${NumberFormat('###,###').format(transaction[index]['amount'])}',
                                                      style: TextStyle(
                                                        color: transaction[
                                                                        index][
                                                                    'status'] ==
                                                                1
                                                            ? Colors.red
                                                            : Colors.green,
                                                        fontSize: 18,
                                                        fontFamily: 'DM Sans',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 0,
                                                      ),
                                                    ),
                                                  )),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10, left: 7),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    transaction[index]
                                                                ['desc'] ==
                                                            ''
                                                        ? 'No Description'
                                                        : transaction[index]
                                                            ['desc'],
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily: 'DM Sans',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      height: 0,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ]),
                                          ),
                                          SizedBox(
                                            width: 170,
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 35),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    DateFormat(
                                                            "EEEE, dd MMM yyyy")
                                                        .format(DateTime.parse(
                                                            transaction[index][
                                                                'date_created'])),
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily: 'DM Sans',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      height: 0,
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                                      Container(
                                          child: Builder(builder: (context) {
                                        return index != transaction.length - 1
                                            ? const SizedBox(
                                                width: 295,
                                                child: Divider(
                                                  height: 20,
                                                  thickness: 1,
                                                  endIndent: 0,
                                                  color: Color(0xFFE6E6E6),
                                                ),
                                              )
                                            : const Text('');
                                      }))
                                    ],
                                  );
                                },
                              ),
                            )),
                    )
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

userData(userInfo) async {
  try {
    Response response = await post(Uri.parse('$API_URL/MainPage'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'email': userInfo['email']}));
    return jsonDecode(response.body);
  } catch (err) {
    debugPrint(err.toString());
  }
}
