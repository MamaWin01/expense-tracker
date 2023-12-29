import 'package:expense_app/widget/subwidget/add_bank.dart';
import 'package:expense_app/widget/subwidget/add_ewallet.dart';
import 'package:expense_app/widget/subwidget/ewallet_info.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:expense_app/Helper/mongodb.dart';
import 'package:expense_app/widget/main_page.dart';
import 'package:expense_app/widget/page_not_found.dart';
import 'package:expense_app/widget/first_page.dart';
import 'package:expense_app/widget/sign_in.dart';
import 'package:expense_app/widget/register.dart';
import 'package:expense_app/widget/add_transaction.dart';
import 'package:expense_app/widget/edit_profile.dart';
import 'package:expense_app/widget/subwidget/bank_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // await MongoDatabase.connect();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  _MyHomePageState createState() => _MyHomePageState();

  static _MyHomePageState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyHomePageState>()!;
}

class _MyHomePageState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: AutoLogin(),
      onGenerateRoute: routeList,
    );
  }
}

class AutoLogin extends StatelessWidget {
  late SharedPreferences prefs;

  getToken() async {
    prefs = await SharedPreferences.getInstance();
    var test = prefs.getString('token');
    var jwtDecodedToken = JwtDecoder.decode(test.toString());

    var now = DateTime.now();
    if (true) {
      return 'yey';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder:
            (BuildContext context, AsyncSnapshot<SharedPreferences> prefs) {
          switch (prefs.connectionState) {
            case ConnectionState.done:
              var x = prefs.data;
              if (x?.getString('token') != null) {
                var test = x?.getString('token');
                var jwtDecodedToken = JwtDecoder.decode(test.toString());
                var now = DateTime.now();
                var exp = now.isAfter(DateTime.fromMillisecondsSinceEpoch(
                    jwtDecodedToken['exp'] * 1000));
                if (exp) {
                  return const First_page();
                } else {
                  return Main_page(
                    token: x?.getString('token'),
                    initialIndex: 0,
                  );
                }
              } else {
                return const First_page();
              }
            default:
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
          }
        });
  }
}

Route<dynamic> routeList(RouteSettings routeSettings) {
  final args = routeSettings.arguments;
  final Route<dynamic> route;
  print('route being use');
  print(args);

  switch (routeSettings.name) {
    case '/':
      route = MaterialPageRoute(
        builder: (context) => const First_page(),
      );
      break;
    case '/login':
      route = MaterialPageRoute(
        builder: (context) => const Login(),
      );
      break;
    case '/register':
      route = MaterialPageRoute(
        builder: (context) => const Register(),
      );
      break;
    case '/mainPage':
      if (args != '') {
        route = MaterialPageRoute(
          builder: (context) => Main_page(
            token: args,
            initialIndex: 0,
          ),
        );
      } else {
        route = MaterialPageRoute(builder: (context) => const PageNotFound());
      }
      break;
    case '/addTransaction':
      route = MaterialPageRoute(
        builder: (context) => const Add_transaction(),
      );
      break;
    case '/edit_profile':
      route = MaterialPageRoute(
        builder: (context) => const EditProfile(),
      );
      break;
    case '/bank_info':
      route = MaterialPageRoute(
        builder: (context) => const BankInfo(),
      );
      break;
    case '/add_bank':
      route = MaterialPageRoute(
        builder: (context) => const AddBank(),
      );
      break;
    case '/ewallet_info':
      route = MaterialPageRoute(
        builder: (context) => const EWalletInfo(),
      );
      break;
    case '/add_ewallet':
      route = MaterialPageRoute(
        builder: (context) => const AddEWallet(),
      );
      break;
    default:
      route = MaterialPageRoute(builder: (context) => const PageNotFound());
      break;
  }

  return route;
}
