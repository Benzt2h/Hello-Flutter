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
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover)),
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('homestack/company');
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.business,
                      size: 80,
                      color: Colors.purple,
                    ),
                    Text(
                      "บริษัท",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                color: Colors.white70,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.map,
                    size: 80,
                    color: Colors.purple,
                  ),
                  Text(
                    "แผนที่",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              color: Colors.white70,
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.camera_alt,
                    size: 80,
                    color: Colors.purple,
                  ),
                  Text(
                    "กล้อง",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              color: Colors.white70,
            ),
            GestureDetector(
              onTap: () async {
                fromAbout = await Navigator.pushNamed(
                    context, 'homestack/about', arguments: {
                  'email': 'benzt2h@hotmail.com',
                  'phone': '08888888'
                });
                setState(() {
                  fromAbout = fromAbout;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.purple,
                    ),
                    Text(
                      "เกี่ยวกับเรา ${fromAbout ?? ''}",
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                color: Colors.white70,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'homestack/room');
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.purple,
                    ),
                    Text(
                      "ห้องพัก",
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
