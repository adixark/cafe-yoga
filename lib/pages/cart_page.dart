import 'package:cafe_yoga/Models/cart_response_model.dart';
import 'package:cafe_yoga/pages/payment_screen.dart';
import 'package:cafe_yoga/pages/verify_address.dart';
import 'package:cafe_yoga/provider/cart_provider.dart';
import 'package:cafe_yoga/provider/loader_provider.dart';
import 'package:cafe_yoga/shared_service.dart';
import 'package:cafe_yoga/utils/progressHUD.dart';
import 'package:cafe_yoga/widgets/widget_cart_product.dart';
import 'package:cafe_yoga/widgets/widget_unauthorised.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();

    var cartItemsList = Provider.of<CartProvider>(context, listen: false);
    cartItemsList.resetStreams();
    cartItemsList.fetchCartitem();
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: SharedService.isLoggedIn(),
      builder: (BuildContext context, AsyncSnapshot<bool> loginModel) {
        if (loginModel.hasData) {
          if (loginModel.data) {
            return Consumer<LoaderProvider>(
              builder: (context, loaderModel, child) {
                return Scaffold(
                  body: ProgressHUD(
                    child: _cartItemsList(),
                    inAsyncCall: loaderModel.apiCallprocess,
                    opacity: 0.3,
                  ),
                );
              },
            );
          } else {
            return UnAuthWidget();
          }
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

Widget _cartItemsList() {
  return new Consumer<CartProvider>(
    builder: (context, cartModel, child) {
      if (cartModel.cartItems != null && cartModel.cartItems.length > 0) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: cartModel.cartItems.length,
                    itemBuilder: (context, index) {
                      return CartProduct(data: cartModel.cartItems[index]);
                    }),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      onPressed: () {
                        Provider.of<LoaderProvider>(context, listen: false)
                            .setLoadingStatus(true);
                        var cartProvider =
                            Provider.of<CartProvider>(context, listen: false);
                        cartProvider.updateCart((val) {
                          Provider.of<LoaderProvider>(context, listen: false)
                              .setLoadingStatus(false);
                        });
                      },
                      color: Colors.green,
                      shape: StadiumBorder(),
                      padding: EdgeInsets.all(10),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(
                            Icons.sync,
                            color: Colors.white,
                          ),
                          Text(
                            "Update Cart",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        new Text(
                          "Total",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          "₹${cartModel.totalAmount}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ],
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VerifyAddress()));
                      },
                      color: Colors.redAccent,
                      shape: StadiumBorder(),
                      padding: EdgeInsets.all(15),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            "CheckOut",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      }
      return Container(
        color: Colors.white,
        child: Center(
          child: Image(
              height: MediaQuery.of(context).size.height,
              image: AssetImage("assets/img/EmptyCart.png")),
        ),
      );
    },
  );
}
