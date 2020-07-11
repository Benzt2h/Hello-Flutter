import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutteronline/redux/appReducer.dart';
import 'package:flutteronline/redux/profile/profileAction.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flushbar/flushbar.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({Key key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  bool _autovalidate = false;
  SharedPreferences prefs;
  bool isLoading = false;

  _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  _updateprofile(Map<String, dynamic> values) async {
    setState(() {
      isLoading = true;
    });
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    var url = 'https://api.codingthailand.com/api/editprofile';
    var res = await http.post(url,
        headers: {
          'Authorization': 'Bearer ${token['access_token']}',
          'Content-Type': 'applicaion/json'
        },
        body: convert.jsonEncode({
          'name': values['name'],
        }));
    if (res.statusCode == 200) {
      setState(() {
        isLoading = false;
      });

      var profile = res.body;
      await _saveProfile(profile);

      Navigator.pushNamedAndRemoveUntil(
          context, 'homestack/home', (Route<dynamic> route) => false);
    } else {
      setState(() {
        isLoading = false;
      });
      var feedback = convert.jsonDecode(res.body);
      Flushbar(
        title: "${feedback['message']}",
        message: "${feedback['message']}",
        icon: Icon(
          Icons.error_outline,
          size: 28.0,
          color: Colors.red[300],
        ),
        duration: Duration(seconds: 3),
        leftBarIndicatorColor: Colors.red[300],
      )..show(context);
    }
  }

  Future<void> _saveProfile(String profile) async {
    var profileUpdate = convert.jsonDecode(profile);
    await prefs.setString(
        'profile', convert.jsonEncode(profileUpdate['data']['user']));
    //call Redux-action
    final store = StoreProvider.of<AppState>(context);
    store.dispatch(getProfileAction(profileUpdate['data']['user']));
  }

  @override
  Widget build(BuildContext context) {
    Map user = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
              child: FormBuilder(
                key: _fbKey,
                initialValue: {
                  'name': user['name'],
                },
                autovalidate: _autovalidate,
                child: Column(
                  children: <Widget>[
                    FormBuilderTextField(
                      attribute: "name",
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: TextStyle(color: Colors.black87),
                        errorStyle: TextStyle(color: Colors.red),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                      validators: [
                        FormBuilderValidators.required(errorText: "Input Name"),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: 200,
                      child: RaisedButton(
                        onPressed: () {
                          if (_fbKey.currentState.saveAndValidate()) {
                            _updateprofile(_fbKey.currentState.value);
                          } else {
                            setState(() {
                              _autovalidate = true;
                            });
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Edit",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            isLoading == true
                                ? CircularProgressIndicator()
                                : Text(''),
                          ],
                        ),
                        padding: EdgeInsets.all(30),
                        color: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
