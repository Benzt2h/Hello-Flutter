import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutteronline/redux/appReducer.dart';
import 'package:flutteronline/redux/profile/profileAction.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flushbar/flushbar.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

  _login(Map<String, dynamic> values) async {
    setState(() {
      isLoading = true;
    });
    var url = 'https://api.codingthailand.com/api/login';
    var res = await http.post(url,
        headers: {'Content-Type': 'applicaion/json'},
        body: convert.jsonEncode({
          'email': values['email'],
          'password': values['password'],
        }));
    if (res.statusCode == 200) {
      setState(() {
        isLoading = false;
      });

      await prefs.setString('token', res.body);
      await _getProfile();

      Navigator.pushNamedAndRemoveUntil(
          context, '/homestack', (Route<dynamic> route) => false);
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

  Future<void> _getProfile() async {
    String url = 'https://api.codingthailand.com/api/profile';
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    var res = await http.get(url,
        headers: {'Authorization': 'Bearer ${token['access_token']}'});
    var profile = convert.jsonDecode(res.body);
    await prefs.setString(
        'profile', convert.jsonEncode(profile['data']['user']));

    //call Redux-action
    final store = StoreProvider.of<AppState>(context);
    store.dispatch(getProfileAction(profile['data']['user']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                Colors.purple[200],
                Theme.of(context).primaryColor
              ])),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Image(
                    image: AssetImage('assets/images/cct_logo.png'),
                    height: 80,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: FormBuilder(
                      key: _fbKey,
                      initialValue: {
                        'email': '',
                        'password': '',
                      },
                      autovalidate: _autovalidate,
                      child: Column(
                        children: <Widget>[
                          FormBuilderTextField(
                            attribute: "email",
                            keyboardType: TextInputType.emailAddress,
                            maxLines: 1,
                            decoration: InputDecoration(
                              labelText: "Email",
                              labelStyle: TextStyle(color: Colors.black87),
                              errorStyle: TextStyle(color: Colors.white),
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                            ),
                            validators: [
                              FormBuilderValidators.email(
                                  errorText: "Input Email Form"),
                              FormBuilderValidators.required(
                                  errorText: "Input Email"),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          FormBuilderTextField(
                            attribute: "password",
                            keyboardType: TextInputType.visiblePassword,
                            maxLines: 1,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: TextStyle(color: Colors.black87),
                              errorStyle: TextStyle(color: Colors.white),
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                            ),
                            validators: [
                              FormBuilderValidators.minLength(3),
                              FormBuilderValidators.required(
                                  errorText: "Input Password"),
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
                                  _login(_fbKey.currentState.value);
                                } else {
                                  setState(() {
                                    _autovalidate = true;
                                  });
                                }
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              padding: EdgeInsets.all(30),
                              color: Colors.deepPurple,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Expanded(
                                  child: MaterialButton(
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                      color: Colors.white,
                                      decoration: TextDecoration.underline),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, "/register");
                                },
                              )),
                              Expanded(
                                  child: MaterialButton(
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                      color: Colors.white,
                                      decoration: TextDecoration.underline),
                                ),
                                onPressed: () {},
                              )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
