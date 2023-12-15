import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Main_page extends StatefulWidget {
  final token;
  const Main_page({this.token, super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<Main_page> {
  late String name;
  late String balance;
  late String ewallet;
  late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    name = jwtDecodedToken['name'];
    fetchData(widget.token);
  }

  fetchData(token) async {
    var data = userData(token);
    balance = '150,000,12';
    ewallet = '100';
  }

  deleteToken() async {
    prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
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
                    'Welcome, $name.',
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
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                balance,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontFamily: 'DM Sans',
                                  fontWeight: FontWeight.w700,
                                  height: 0,
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
                            child:
                                Image.asset('assets/icon/icon.png', width: 50)),
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
                              child: Text(
                                ewallet,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontFamily: 'DM Sans',
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                ),
                              ),
                            )
                          ]),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

userData(token) {}
