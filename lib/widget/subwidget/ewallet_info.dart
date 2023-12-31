import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart';
import 'package:expense_app/widget/main_page.dart';
import 'package:expense_app/Helper/constant.dart';
import 'package:expense_app/Helper/function.dart';

class EWalletInfo extends StatefulWidget {
  const EWalletInfo({super.key});

  @override
  _EWalletState createState() => _EWalletState();
}

TextEditingController NameController = TextEditingController();
TextEditingController AmountController = TextEditingController();

class _EWalletState extends State<EWalletInfo> {
  dynamic name = '';
  dynamic eWalletInfo = [];
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    var prefs = await SharedPreferences.getInstance();
    var test = prefs?.getString('token');
    var jwtDecodedToken = JwtDecoder.decode(test.toString());
    var data = await getBankOrEWalletInfo(jwtDecodedToken, 1);
    if (mounted) {
      setState(() {
        name = "${jwtDecodedToken['name']}";
        eWalletInfo = data['data'];
      });
    }
  }

  _popupSetting(context, type, id, index) async {
    if (type == 'Delete') {
      try {
        Response response =
            await post(Uri.parse('$API_URL/deleteBankOrEWallet'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode({'type': 1, 'id': id}));

        if (response.statusCode == 200) {
          showDialog(
              // barrierDismissible: false,
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("EWallet Account"),
                  backgroundColor: Colors.white,
                  content: Text("EWallet Account added successfully Deleted"),
                );
              });
          Timer(const Duration(seconds: 1), () {
            fetchData();
            Navigator.of(context).pop();
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
      } catch (exp) {
        debugPrint(exp.toString());
      }
    } else {
      setState(() {
        NameController.text = eWalletInfo[index]['wallet_name'].toString();
        AmountController.text = NumberFormat('###,###')
            .format(eWalletInfo[index]['balance'])
            .toString();
      });
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Edit EWallet Info"),
                content: Stack(fit: StackFit.loose, children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        textAlign: TextAlign.justify,
                        controller: NameController,
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
                          labelText: "EWallet name",
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
                            borderSide: const BorderSide(
                                width: 0.50, color: Color(0xFF828282)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2.5, color: Color(0xFF31A062)),
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
                    ],
                  )
                ]),
                backgroundColor: Colors.white,
                actions: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    enableFeedback: false,
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      editData(context, id);
                    },
                    enableFeedback: false,
                    child: const Text('Save'),
                  ),
                ],
              ));
    }
  }

  editData(context, id) async {
    var prefs = await SharedPreferences.getInstance();
    var test = prefs?.getString('token');
    var infoname = NameController.text.toString();
    var amount = AmountController.text.toString();
    var userData = JwtDecoder.decode(test.toString());
    if (amount != '') {
      amount = amount.replaceAll(RegExp(r"\D"), "");
    } else {
      amount = '0';
    }
    try {
      Response response = await post(Uri.parse('$API_URL/editBankOrEWallet'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'type': 1,
            'id': id,
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
                title: Text("Edit EWallet Info"),
                backgroundColor: Colors.white,
                content: Text("EWallet Account successfully edited"),
              );
            });
        Timer(const Duration(seconds: 1), () {
          Navigator.pushNamed(context, '/ewallet_info');
        });
      } else {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text("Edit EWallet Info"),
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
    } catch (exp) {
      debugPrint(exp.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'EWallet Info',
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
                  builder: (context) => const Main_page(
                    initialIndex: 2,
                  ),
                ),
              );
            },
          ),
        ),
        body: Container(
          width: 414,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(color: Color(0xFFFAFAFA)),
          child: Padding(
            padding: EdgeInsets.only(
              top: 10,
              right: 30,
              left: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    flex: 1,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: eWalletInfo == null ? 0 : eWalletInfo.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.only(bottom: 10),
                            constraints: const BoxConstraints(
                                minHeight: 80,
                                minWidth: double.infinity,
                                maxHeight: 100),
                            child: Card(
                                color: Colors.white,
                                clipBehavior: Clip.hardEdge,
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Icon(Icons.account_balance_wallet),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          eWalletInfo[index]['wallet_name'],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                            "Rp ${NumberFormat('###,###').format(eWalletInfo[index]['balance'])}")
                                      ],
                                    ),
                                    const Spacer(),
                                    PopupMenuButton(
                                      enableFeedback: false,
                                      icon: const Icon(Icons.more_vert),
                                      itemBuilder: (BuildContext context) {
                                        return [
                                          const PopupMenuItem(
                                            value: 'Edit',
                                            child: Text('Edit'),
                                          ),
                                          const PopupMenuItem(
                                            value: 'Delete',
                                            child: Text('Delete'),
                                          ),
                                        ];
                                      },
                                      onSelected: (value) {
                                        _popupSetting(context, value,
                                            eWalletInfo[index]['_id'], index);
                                      },
                                    )
                                  ],
                                )),
                          );
                        })),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/add_ewallet');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF31A062),
                      fixedSize: const Size(300, 30),
                      enableFeedback: false),
                  child: const Text(
                    'Add EWallet Info',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ));
  }
}
