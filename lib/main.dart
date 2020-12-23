import 'package:cafe_yoga/pages/home_page.dart';
import 'package:cafe_yoga/pages/product_page.dart';
import 'package:cafe_yoga/pages/signup_page.dart';
import 'package:cafe_yoga/pages/login_page.dart';
import 'package:cafe_yoga/provider/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => ProductProvider(),
            child: ProductPage(),
          ),
        ],
        child: MaterialApp(
          theme: ThemeData(accentColor: Colors.orange),
          title: "cafe_yoga",
          debugShowCheckedModeBanner: false,
          home: HomePage(),
        ));
  }
}
