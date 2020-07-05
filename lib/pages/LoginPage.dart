import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  bool _autovalidate = false;
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
                                  print(_fbKey.currentState.value);
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
