import 'package:cafe_yoga/pages/my_account.dart';
import 'package:flutter/material.dart';

import 'package:cafe_yoga/Models/payment_method.dart';
import 'package:cafe_yoga/pages/cart_page.dart';
import 'package:cafe_yoga/pages/dashboard_page.dart';
import 'package:cafe_yoga/pages/payment_screen.dart';
import 'package:cafe_yoga/widgets/widget_payment_method_list.dart';

class HomePage extends StatefulWidget {
  int selectedPage;

  HomePage({
    Key key,
    this.selectedPage,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> _widgetList = [
    DashboardPage(),
    CartPage(),
    DashboardPage(),
    MyAccount(),
  ];

  int _index = 0;

  @override
  void initState() {
    super.initState();
    if (this.widget.selectedPage != null) {
      _index = this.widget.selectedPage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined), label: "Store"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "My Cart"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_outlined), label: "Favourites"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined), label: "My Account"),
        ],
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.black,
        currentIndex: _index,
        type: BottomNavigationBarType.shifting,
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
      ),
      body: _widgetList[_index],
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      brightness: Brightness.dark,
      elevation: 0,
      backgroundColor: Colors.redAccent,
      automaticallyImplyLeading: false,
      title: Text(
        "Cafe Yoga",
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        Icon(
          Icons.notifications_none,
          color: Colors.white,
        ),
        SizedBox(width: 15),
      ],
    );
  }
}
