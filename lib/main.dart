import 'package:flutter/material.dart';
import 'package:flutteronline/pages/HomeStack.dart';
import 'package:flutteronline/pages/LoginPage.dart';
import 'package:flutteronline/pages/NewsStack.dart';
import 'package:flutteronline/pages/ProductStack.dart';
import 'package:flutteronline/pages/RegisterPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

String token;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  token = prefs.getString('token');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        //primarySwatch: Colors.blue,
        primaryColor: Colors.purple,
        accentColor: Colors.purpleAccent,
        canvasColor: Colors.purple[50],
        textTheme:
            TextTheme(headline1: TextStyle(color: Colors.green, fontSize: 50)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: HomePage(),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => token == null ? LoginPage() : HomeStack(),
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
        '/homestack': (context) => HomeStack(),
        '/productstack': (context) => ProductStack(),
        '/newsstack': (context) => NewsStack(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
