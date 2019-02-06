import 'dart:io';

import 'package:flutter/material.dart';
import 'package:governmentnews/Pages/MainPage.dart';
import 'Screens/MainScreen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Government News',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        // This is the theme of your application.
        primaryColor : new Color.fromRGBO(68, 68, 68, 1.0),
        bottomAppBarColor: new Color.fromRGBO(68, 68, 68, 1.0),
      ),
      home: Platform.isIOS ? new MainScreen() : new MainPage(),
    );
  }
}
