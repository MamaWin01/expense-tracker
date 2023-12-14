import 'package:expense_app/Helper/mongodb.dart';
import 'package:expense_app/widget/main_page.dart';
import 'package:flutter/material.dart';
import 'package:expense_app/widget/page_not_found.dart';
import 'package:expense_app/widget/first_page.dart';
import 'package:expense_app/widget/sign_in.dart';
import 'package:expense_app/widget/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();
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
      initialRoute: '/',
      onGenerateRoute: routeList,
    );
  }
}

Route<dynamic> routeList(RouteSettings routeSettings) {
  final args = routeSettings.arguments;
  final Route<dynamic> route;

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
          builder: (context) => Main_page(token: args),
        );
      } else {
        route = MaterialPageRoute(builder: (context) => const PageNotFound());
      }
      break;
    default:
      route = MaterialPageRoute(builder: (context) => const PageNotFound());
      break;
  }

  return route;
}
