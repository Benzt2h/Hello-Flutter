import 'package:flutter/material.dart';
import 'package:flutteronline/widgets/logo.dart';
import 'package:flutteronline/widgets/menu.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var fromAbout;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu(),
      appBar: AppBar(
        title: const Logo(),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              'from Aboutpage is ${fromAbout ?? ''}',
            ),
            RaisedButton(
              child: Text("เกี่ยวกับเรา"),
              onPressed: () async {
                fromAbout = await Navigator.pushNamed(
                    context, 'homestack/about', arguments: {
                  'email': 'benzt2h@hotmail.com',
                  'phone': '08888888'
                });
                setState(() {
                  fromAbout = fromAbout;
                });
              },
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
