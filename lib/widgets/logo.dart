import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  
  const Logo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('logo build');
    return Image.asset('assets/images/cct_logo.png', height: 40, fit: BoxFit.cover);
  }
}