import 'package:cafe_yoga/pages/signup_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "cafe_yoga",
      debugShowCheckedModeBanner: false,
      home: SignupPage(),
    );
  }
}
