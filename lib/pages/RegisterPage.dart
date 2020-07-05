import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  bool _autovalidate = false;

  _register(Map<String, dynamic> values) async {
    var url = 'https://api.codingthailand.com/api/register';
    var res = await http.post(url,
        headers: {'Content-Type': 'applicaion/json'},
        body: convert.jsonEncode({
          'name': values['name'],
          'email': values['email'],
          'password': values['password'],
          'dob': values['dob'].toString().substring(0, 10)
        }));
    if (res.statusCode == 201) {
      var feedback = convert.jsonDecode(res.body);
      Flushbar(
        title: "${feedback['message']}",
        message: "${feedback['status']}",
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.blue[300],
        ),
        duration: Duration(seconds: 3),
        leftBarIndicatorColor: Colors.blue[300],
      )..show(context);
      Future.delayed(Duration(seconds: 3));
      Navigator.pop(context);
    } else {
      var feedback = convert.jsonDecode(res.body);
      Flushbar(
        title: "${feedback['message']}",
        message: "${feedback['errors']['email'][0]}}",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
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
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: FormBuilder(
                      key: _fbKey,
                      initialValue: {
                        'name': '',
                        'email': '',
                        'password': '',
                        'dob': DateTime.now(),
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
                              errorStyle: TextStyle(color: Colors.white),
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                            ),
                            validators: [
                              FormBuilderValidators.required(
                                  errorText: "Input Name"),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
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
                            height: 20,
                          ),
                          FormBuilderDateTimePicker(
                            attribute: "dob",
                            inputType: InputType.date,
                            format: DateFormat("yyyy-MM-dd"),
                            decoration: InputDecoration(
                              labelText: "Day of Birth",
                              labelStyle: TextStyle(color: Colors.black87),
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: 200,
                            child: RaisedButton(
                              onPressed: () {
                                if (_fbKey.currentState.saveAndValidate()) {
                                  //print(_fbKey.currentState.value);
                                  _register(_fbKey.currentState.value);
                                } else {
                                  setState(() {
                                    _autovalidate = true;
                                  });
                                }
                              },
                              child: Text(
                                "Register",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
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
          ),
        ),
      ),
    );
  }
}
