import 'package:flutter/material.dart';
import 'package:lightfire/Screens/connect.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MediaQuery(
      data: new MediaQueryData(),
      child: new MaterialApp(home: new Home())
);
  }
}