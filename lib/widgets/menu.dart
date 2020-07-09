import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class Menu extends StatefulWidget {
  Menu({Key key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  Map<String, dynamic> profile = {'name': '', 'email': '', 'role': ''};

  _getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var profileString = prefs.getString('profile');
    if (profileString != null) {
      setState(() {
        profile = convert.jsonDecode(profileString);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            /*DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text(
                'เมนูหลัก',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            )*/
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/images/me.png'),
              ),
              accountName: Text('${profile['name']}'),
              accountEmail: Text('${profile['email']} Role:${profile['role']}'),
              otherAccountsPictures: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.pushNamed(context, 'homestack/editprofile',
                        arguments: {'name': profile['name']});
                  },
                )
              ],
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('หน้าหลัก'),
              selected: ModalRoute.of(context).settings.name == 'homestack/home'
                  ? true
                  : false,
              trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context, rootNavigator: true)
                    .pushNamedAndRemoveUntil('/homestack', (route) => false);
              },
            ),
            ListTile(
              leading: Icon(Icons.all_out),
              title: Text('สินค้า'),
              selected:
                  ModalRoute.of(context).settings.name == 'productstack/product'
                      ? true
                      : false,
              trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context, rootNavigator: true)
                    .pushNamedAndRemoveUntil('/productstack', (route) => false);
              },
            ),
            ListTile(
              leading: Icon(Icons.all_out),
              title: Text('ข่าวสาร'),
              selected: ModalRoute.of(context).settings.name == 'newsstack/news'
                  ? true
                  : false,
              trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context, rootNavigator: true)
                    .pushNamedAndRemoveUntil('/newsstack', (route) => false);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
