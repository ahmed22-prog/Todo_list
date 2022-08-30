import 'package:aaa/modules/Massenger/Massenger.dart';
import 'package:aaa/layout/home.dart';
import 'package:aaa/modules/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'modules/firsthome/aaa.dart';
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
