import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:expense_app/Helper/constant.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Add_transaction extends StatefulWidget {
  const Add_transaction({super.key});

  @override
  _AddTransasctionState createState() => _AddTransasctionState();
}

TextEditingController DatetimeController = TextEditingController();
TextEditingController AmountController = TextEditingController();
TextEditingController DescController = TextEditingController();
TextEditingController StatusController = TextEditingController();
TextEditingController TypeController = TextEditingController();

class _AddTransasctionState extends State<Add_transaction> {
  String? _dropDownValue;
  String? _dropDownValue2;
  bool ispress = false;
  late SharedPreferences prefs;
  NumberFormat currencyFormatter = NumberFormat('###,###');

  void CreateTransaction(context, prefs) async {
    var datetime = DatetimeController.text.toString();
    var amount = AmountController.text.toString();
    var desc = DescController.text.toString();
    var status = StatusController.text.toString();
    var type = TypeController.text.toString();
    var userData = JwtDecoder.decode(prefs.getString('token'));
    if (datetime == '') {
      datetime = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
    if (amount != '') {
      amount = amount.replaceAll(RegExp(r"\D"), "");
    } else {
      amount = '0';
    }
    desc = desc == '' ? '' : desc;
    status = status == '' ? '0' : status;
    type = type == '' ? '0' : type;
    try {
      Response response = await post(Uri.parse('$API_URL/addTransaction'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'email': userData['email'],
            'date_created': datetime,
            'name': userData['name'],
            'amount': amount,
            'desc': desc,
            'status': status,
            'type': type
          }));

      if (response.statusCode == 200) {
        showDialog(
            // barrierDismissible: false,
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Transaction"),
                backgroundColor: Colors.white,
                content: Text(
                    "Transaction added successfully, Redirecting to home page"),
              );
            });
        Timer(const Duration(seconds: 1), () {
          Navigator.pushNamed(context, '/mainPage',
              arguments: prefs.getString('token'));
        });
      } else {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text("Transaction"),
                  content: Text(
                      "Transaction Failed, ${jsonDecode(response.body)['error'].toString()}"),
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

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        DatetimeController.text = '';
        AmountController.text = '';
        DescController.text = '';
        StatusController.text = '';
        TypeController.text = '';
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
          leading: GestureDetector(
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
          ),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Add new transaction',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      TextField(
                        controller: DatetimeController,
                        readOnly: true,
                        decoration: InputDecoration(
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
                          hintText:
                              DateFormat('yyyy-MM-dd').format(DateTime.now()),
                          prefixIcon: const Icon(Icons.calendar_today),
                        ),
                        onTap: () async {
                          dynamic pickedDate = await showDatePicker(
                              context: context,
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                        // primary: Colors
                                        //     .green, // header background color
                                        // onPrimary: Colors.black,
                                        // onSurface: Colors.black
                                        ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        enableFeedback: false,
                                        foregroundColor:
                                            Colors.black, // button text color
                                      ),
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                              initialEntryMode:
                                  DatePickerEntryMode.calendarOnly,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101));
                          if (pickedDate != null) {
                            //pickedDate output format => 2021-03-10 00:00:00.000
                            String formattedDate = DateFormat('yyyy-MM-dd').format(
                                pickedDate); //formatted date output using intl package =>  2021-03-16
                            //you can implement different kind of Date Format here according to your requirement

                            setState(() {
                              DatetimeController.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          } else {
                            debugPrint("Date is not selected");
                          }
                        },
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w400,
                          height: 1,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
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
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: DescController,
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
                          labelText: "Description",
                        ),
                        maxLines: 3,
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w400,
                          height: 1,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownButtonFormField(
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
                        ),
                        enableFeedback: false,
                        hint: _dropDownValue == null
                            ? const Text('Status')
                            : Text(
                                _dropDownValue.toString(),
                                style: const TextStyle(color: Colors.black),
                              ),
                        isExpanded: true,
                        iconSize: 15.0,
                        style: const TextStyle(color: Colors.black),
                        value: 'Payment',
                        items: ['Payment', 'Income'].map(
                          (val) {
                            return DropdownMenuItem<String>(
                              value: val,
                              child: Text(val),
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
                              }
                              _dropDownValue = val.toString();
                            },
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownButtonFormField(
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
                        ),
                        enableFeedback: false,
                        hint: _dropDownValue2 == null
                            ? const Text('Payment Type')
                            : Text(
                                _dropDownValue2.toString(),
                                style: const TextStyle(color: Colors.black),
                              ),
                        isExpanded: true,
                        iconSize: 15.0,
                        style: const TextStyle(color: Colors.black),
                        items: ['Bank', 'EWallet', 'Cash/Other'].map(
                          (val) {
                            return DropdownMenuItem<String>(
                              value: val,
                              child: Text(val),
                            );
                          },
                        ).toList(),
                        value: 'Bank',
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
                              }
                              _dropDownValue2 = newval;
                            },
                          );
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF31A062),
                              fixedSize: const Size(300, 30),
                              enableFeedback: false),
                          onPressed: ispress
                              ? null
                              : () {
                                  ispress
                                      ? null
                                      : CreateTransaction(context, prefs);
                                  setState(() {
                                    ispress = true;
                                  });
                                },
                          child: Text(
                            ispress ? 'Processing...' : 'Add Transaction',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          )),
                    ],
                  ),
                ))));
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  final validationRegex = RegExp(r'^[\d,]*\.?\d*$');
  final replaceRegex = RegExp(r'[^\d\.]+');
  static const fractionalDigits = 2;
  static const thousandSeparator = ',';
  static const decimalSeparator = '.';

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (!validationRegex.hasMatch(newValue.text)) {
      return oldValue;
    }

    final newValueNumber = newValue.text.replaceAll(replaceRegex, '');

    var formattedText = newValueNumber;

    /// Add thousand separators.
    var index = newValueNumber.contains(decimalSeparator)
        ? newValueNumber.indexOf(decimalSeparator)
        : newValueNumber.length;

    while (index > 0) {
      index -= 3;

      if (index > 0) {
        formattedText = formattedText.substring(0, index) +
            thousandSeparator +
            formattedText.substring(index, formattedText.length);
      }
    }

    /// Limit the number of decimal digits.
    final decimalIndex = formattedText.indexOf(decimalSeparator);
    var removedDecimalDigits = 0;

    if (decimalIndex != -1) {
      var decimalText = formattedText.substring(decimalIndex + 1);

      if (decimalText.isNotEmpty && decimalText.length > fractionalDigits) {
        removedDecimalDigits = decimalText.length - fractionalDigits;
        decimalText = decimalText.substring(0, fractionalDigits);
        formattedText = formattedText.substring(0, decimalIndex) +
            decimalSeparator +
            decimalText;
      }
    }

    /// Check whether the text is unmodified.
    if (oldValue.text == formattedText) {
      return oldValue;
    }

    /// Handle moving cursor.
    final initialNumberOfPrecedingSeparators =
        oldValue.text.characters.where((e) => e == thousandSeparator).length;
    final newNumberOfPrecedingSeparators =
        formattedText.characters.where((e) => e == thousandSeparator).length;
    final additionalOffset =
        newNumberOfPrecedingSeparators - initialNumberOfPrecedingSeparators;

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(
          offset: newValue.selection.baseOffset +
              additionalOffset -
              removedDecimalDigits),
    );
  }
}
