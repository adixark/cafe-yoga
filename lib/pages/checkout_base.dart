import 'package:cafe_yoga/provider/loader_provider.dart';
import 'package:cafe_yoga/utils/progressHUD.dart';
import 'package:cafe_yoga/utils/widget_checkpoints.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckOutBasePage extends StatefulWidget {
  @override
  CheckOutBasePageState createState() => CheckOutBasePageState();
}

class CheckOutBasePageState<T extends CheckOutBasePage> extends State<T> {
  int currentPage = 0;
  bool showBackButton = true;
  @override
  void initState() {
    print("CheckOutBasePage: initState()");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoaderProvider>(
      builder: (context, loaderModel, child) {
        return Scaffold(
          appBar: _buildAppBar(),
          backgroundColor: Colors.white,
          body: ProgressHUD(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CheckPoints(
                    checkedTill: currentPage,
                    checkPoints: ["Shipping", "Payment", "Order"],
                    checkPointsFilledColor: Colors.green,
                  ),
                  Divider(),
                  pageUI(),
                ],
              ),
            ),
            inAsyncCall: loaderModel.apiCallprocess,
            opacity: 0.3,
          ),
        );
      },
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      brightness: Brightness.dark,
      elevation: 0,
      backgroundColor: Colors.redAccent,
      automaticallyImplyLeading: showBackButton,
      title: Text(
        "Checkout",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      actions: [],
    );
  }

  Widget pageUI() {
    return null;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
