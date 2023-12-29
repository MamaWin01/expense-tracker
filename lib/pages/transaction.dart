import 'package:expense_app/pages/home.dart';
import 'package:expense_app/widget/main_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:expense_app/Helper/function.dart';
import 'package:expense_app/Helper/constant.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  _TransactionState createState() => _TransactionState();
}

TextEditingController StatusController = TextEditingController();
TextEditingController TypeController = TextEditingController();
TextEditingController DatetimeController = TextEditingController();

class _TransactionState extends State<Transaction> {
  dynamic name = 'loading...';
  bool ispress = false;
  dynamic balance = 0;
  dynamic ewallet = 0;
  dynamic transaction = [];
  String? _dropDownValue2;
  String? _dropDownValue;
  late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    setState(() {
      DatetimeController.text = '';
    });
    fetchData();
  }

  fetchData() async {
    var reqDate = DatetimeController.text;
    var status = (StatusController.text == '' || StatusController.text == 'all')
        ? ''
        : StatusController.text;
    var type = (TypeController.text == '' || TypeController.text == 'all')
        ? ''
        : TypeController.text;
    var prefs = await SharedPreferences.getInstance();
    var test = prefs?.getString('token');
    var jwtDecodedToken = JwtDecoder.decode(test.toString());
    var data = await transactionData(jwtDecodedToken, reqDate, status, type);
    if (mounted) {
      setState(() {
        transaction = data['transaction'];
        ispress = false;
      });
    }
  }

  _transDetail(context, trans) {
    var statusInfo = '';
    var typeInfo = '';
    if (trans['status'] == 0) {
      statusInfo = 'Payment';
    } else {
      statusInfo = 'Income';
    }
    if (trans['status'] == 0) {
      typeInfo = 'Bank';
    } else if (trans['status'] == 1) {
      typeInfo = 'E-Wallet';
    } else {
      typeInfo = 'Cash/Other';
    }
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Transaction Detail"),
              content: Expanded(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Date: ${DateFormat("EEEE, dd MMM yyyy").format(DateTime.parse(trans['date_created']))}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Status: $statusInfo',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Amount: Rp ${NumberFormat('###,###').format(trans['amount'])}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Type: $typeInfo',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        child: Text(
                          'Desc: ${trans['desc']}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      )),
                ]),
              ),
              backgroundColor: const Color(0xFFFAFAFA),
              actions: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  enableFeedback: false,
                  child: const Text('back'),
                )
              ],
            ));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Transaction',
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
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      fetchData();
                      return LoadingDialog();
                    },
                  );
                  Future.delayed(Duration(seconds: 2), () {
                    Navigator.of(context).pop();
                  });
                },
                child: const Icon(
                  Icons.refresh,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: Container(
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
            child: Column(children: [
              SizedBox(
                height: 40,
                width: 310,
                child: TextField(
                  controller: DatetimeController,
                  readOnly: true,
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.only(top: 10.0, right: 50.0),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 0.50, color: Color(0xFF828282)),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 2.5, color: Color(0xFF31A062)),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    hintText: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                    prefixIcon: const Icon(Icons.calendar_month),
                  ),
                  onTap: () async {
                    dynamic pickedDate = await showDatePicker(
                        context: context,
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  enableFeedback: false,
                                  foregroundColor: Colors.black,
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101));
                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      setState(() {
                        DatetimeController.text = formattedDate;
                      });
                    } else {
                      setState(() {
                        DatetimeController.text = '';
                      });
                      print("Date is not selected");
                    }
                  },
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w400,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    height: 40,
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(top: 5.0),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 0.50, color: Color(0xFF828282)),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 2.5, color: Color(0xFF31A062)),
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      enableFeedback: false,
                      hint: _dropDownValue == null
                          ? const Text('Status')
                          : Text(
                              _dropDownValue.toString(),
                              style: const TextStyle(color: Colors.black),
                            ),
                      isExpanded: true,
                      icon: const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(Icons.arrow_drop_down),
                      ),
                      style: const TextStyle(color: Colors.black),
                      value: 'All',
                      items: ['All', 'Payment', 'Income'].map(
                        (val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Center(child: Text(val)),
                          );
                        },
                      ).toList(),
                      onChanged: (val) {
                        setState(
                          () {
                            var newval = val.toString();
                            if (newval == 'Payment') {
                              StatusController.text = '0';
                            } else if (newval == 'Income') {
                              StatusController.text = '1';
                            } else {
                              StatusController.text = '101';
                            }
                            _dropDownValue = val.toString();
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 150,
                    height: 40,
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(top: 5.0),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 0.50, color: Color(0xFF828282)),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 2.5, color: Color(0xFF31A062)),
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      enableFeedback: false,
                      hint: _dropDownValue2 == null
                          ? const Text('Payment Type')
                          : Text(
                              _dropDownValue2.toString(),
                              style: const TextStyle(color: Colors.black),
                            ),
                      isExpanded: true,
                      icon: const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(Icons.arrow_drop_down),
                      ),
                      style: const TextStyle(color: Colors.black),
                      items: ['All', 'Bank', 'EWallet', 'Cash/Other'].map(
                        (val) {
                          return DropdownMenuItem<String>(
                              value: val,
                              child: Center(
                                child: Text(
                                  val,
                                ),
                              ));
                        },
                      ).toList(),
                      value: 'All',
                      onChanged: (val) {
                        setState(
                          () {
                            var newval = val.toString();
                            if (newval == 'Bank') {
                              TypeController.text = '0';
                            } else if (newval == 'EWallet') {
                              TypeController.text = '1';
                            } else if (newval == 'Cash/Other') {
                              TypeController.text = '2';
                            } else {
                              TypeController.text = '101';
                            }
                            _dropDownValue2 = newval;
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 310,
                height: 40,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF31A062),
                        fixedSize: const Size(300, 30),
                        enableFeedback: false),
                    onPressed: ispress
                        ? null
                        : () {
                            ispress ? null : fetchData();
                            setState(() {
                              ispress = true;
                            });
                          },
                    child: Text(
                      ispress ? 'Searching' : 'Search',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    )),
              ),
              const SizedBox(
                height: 25,
              ),
              Expanded(
                  child: Column(children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'History',
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
                Expanded(
                    child: transaction?.length == 0
                        ? const Text('No Recent History...')
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                transaction == null ? 0 : transaction.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _transDetail(context, transaction[index]);
                                    },
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 140,
                                          child: Column(children: [
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10, left: 7),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    'Rp ${NumberFormat('###,###').format(transaction[index]['amount'])}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: transaction[index]
                                                                  ['status'] ==
                                                              0
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
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  transaction[index]['desc'] ==
                                                          ''
                                                      ? 'No Description'
                                                      : transaction[index]
                                                          ['desc'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontFamily: 'DM Sans',
                                                    fontWeight: FontWeight.w500,
                                                    height: 0,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ]),
                                        ),
                                        SizedBox(
                                          width: 190,
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
                                                    fontWeight: FontWeight.w500,
                                                    height: 0,
                                                  ),
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(child: Builder(builder: (context) {
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
                            })),
              ]))
            ])),
      ),
    );
  }
}

class LoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          )
        ],
      ),
    );
  }
}
