import 'package:cafe_yoga/provider/cart_provider.dart';
import 'package:cafe_yoga/provider/loader_provider.dart';
import 'package:cafe_yoga/utils/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BasePage extends StatefulWidget {
  BasePage({Key key}) : super(key: key);
  @override
  BasePageState createState() => BasePageState();
}

class BasePageState<T extends BasePage> extends State<T> {
  bool _isApiCallProcess = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<LoaderProvider>(builder: (context, loaderModel, child) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: ProgressHUD(
          child: pageUI(),
          inAsyncCall: loaderModel.apiCallprocess,
          opacity: 0.3,
        ),
      );
    });
  }

  Widget pageUI() {
    return null;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      brightness: Brightness.dark,
      elevation: 0,
      backgroundColor: Colors.redAccent,
      automaticallyImplyLeading: true,
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
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: new Container(
            height: 150.0,
            width: 30.0,
            child: new GestureDetector(
              onTap: () {},
              child: new Stack(
                children: <Widget>[
                  new IconButton(
                    icon: new Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                    onPressed: null,
                  ),
                  Provider.of<CartProvider>(context, listen: false)
                              .cartItems
                              .length ==
                          0
                      ? new Container()
                      : new Positioned(
                          child: new Stack(
                          children: <Widget>[
                            new Icon(Icons.brightness_1,
                                size: 20.0, color: Colors.green[800]),
                            new Positioned(
                                top: 3.0,
                                right: 4.0,
                                child: new Center(
                                  child: new Text(
                                    Provider.of<CartProvider>(context,
                                            listen: false)
                                        .cartItems
                                        .length
                                        .toString(),
                                    style: new TextStyle(
                                        color: Colors.white,
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )),
                          ],
                        )),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
