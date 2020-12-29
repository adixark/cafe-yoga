import 'package:cafe_yoga/pages/checkout_base.dart';
import 'package:cafe_yoga/pages/home_page.dart';
import 'package:cafe_yoga/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderSuccessWidget extends CheckOutBasePage {
  @override
  _OrderSuccessWidgetState createState() => _OrderSuccessWidgetState();
}

class _OrderSuccessWidgetState
    extends CheckOutBasePageState<OrderSuccessWidget> {
  @override
  void initState() {
    this.currentPage = 2;
    this.showBackButton = false;
    var orderProvider = Provider.of<CartProvider>(context, listen: false);

    orderProvider.createOrder();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
        builder: (context, orderModel, child) {
          if (orderModel.isOrderCreated) {
            return Center(
              child: Container(
                margin: EdgeInsets.only(top: 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                            ),
                          ),
                          child:
                              Icon(Icons.check, color: Colors.green, size: 90),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Opacity(
                      opacity: 0.6,
                      child: Text(
                        "Your Order has been successfully submited.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FlatButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                              ModalRoute.withName("/Home"));
                        },
                        child: Text(
                          "Done",
                          style: TextStyle(color: Colors.white),
                        ))
                  ],
                ),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
        child: Container());
  }
}
