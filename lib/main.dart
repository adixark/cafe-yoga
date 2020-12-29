import 'package:cafe_yoga/pages/base_page.dart';
import 'package:cafe_yoga/pages/cart_page.dart';
import 'package:cafe_yoga/pages/home_page.dart';
import 'package:cafe_yoga/pages/orders_page.dart';
import 'package:cafe_yoga/pages/paypal_payment.dart';
import 'package:cafe_yoga/pages/product_details.dart';
import 'package:cafe_yoga/pages/product_page.dart';
import 'package:cafe_yoga/pages/signup_page.dart';
import 'package:cafe_yoga/pages/login_page.dart';
import 'package:cafe_yoga/provider/cart_provider.dart';
import 'package:cafe_yoga/provider/loader_provider.dart';
import 'package:cafe_yoga/provider/order_provider.dart';
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
          ChangeNotifierProvider(
            create: (context) => LoaderProvider(),
            child: BasePage(),
          ),
          ChangeNotifierProvider(
            create: (context) => CartProvider(),
            child: ProductDetail(),
          ),
          ChangeNotifierProvider(
            create: (context) => CartProvider(),
            child: CartPage(),
          ),
          ChangeNotifierProvider(
            create: (context) => OrderProvider(),
            child: OrdersPage(),
          ),
        ],
        child: MaterialApp(
          title: "cafe_yoga",
          debugShowCheckedModeBanner: false,
          home: HomePage(),
          routes: <String, WidgetBuilder>{
            '/PayPal': (BuildContext context) => new PaypalPaymentScreen()
          },
          theme: ThemeData(
            fontFamily: "ProductSans",
            primaryColor: Colors.white,
            floatingActionButtonTheme: FloatingActionButtonThemeData(
                elevation: 0, foregroundColor: Colors.white),
            brightness: Brightness.light,
            accentColor: Colors.redAccent,
            dividerColor: Colors.redAccent,
            focusColor: Colors.redAccent,
            hintColor: Colors.redAccent,
            textTheme: TextTheme(
              headline4: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.redAccent,
                  height: 1.3),
              headline2: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.redAccent,
                  height: 1.4),
              headline3: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.redAccent,
                  height: 1.3),
              subtitle1: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  height: 1.3),
              caption: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey,
                  height: 1.3),
            ),
          ),
        ));
  }
}
