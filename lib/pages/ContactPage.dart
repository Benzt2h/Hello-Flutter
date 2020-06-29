import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  ContactPage({Key key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ติดต่อเรา')),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('ติดต่อเรา'),
              RaisedButton(
                child: Text('กลับหน้า Home'),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, 'homestack/home',
                      (Route<dynamic> route) => false);
                  //Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
                },
              )
            ]),
      ),
    );
  }
}
