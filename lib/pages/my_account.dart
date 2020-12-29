import 'package:cafe_yoga/Models/login_model.dart';
import 'package:cafe_yoga/pages/login_page.dart';
import 'package:cafe_yoga/pages/orders_page.dart';
import 'package:cafe_yoga/shared_service.dart';
import 'package:cafe_yoga/widgets/widget_unauthorised.dart';
import 'package:flutter/material.dart';

class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class OptionsList {
  String optionTitle;
  String optionSubTitle;
  IconData optionIcon;
  Function onTap;
  OptionsList(
    this.optionIcon,
    this.optionTitle,
    this.optionSubTitle,
    this.onTap,
  );
}

class _MyAccountState extends State<MyAccount> {
  List<OptionsList> options = new List<OptionsList>();

  @override
  void initState() {
    super.initState();
    options.add(
      new OptionsList(Icons.shopping_bag, "Orders", "Check my Orders", () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => OrdersPage()));
      }),
    );
    options.add(
      new OptionsList(Icons.edit, "Edit Profile", "Update your profile.", () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => OrdersPage()));
      }),
    );
    options.add(
      new OptionsList(Icons.notifications, "Notifications",
          "Check the latest notification.", () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => OrdersPage()));
      }),
    );
    options.add(
      new OptionsList(Icons.power_settings_new, "Sign out", "", () {
        SharedService.logout().then((value) => {
              setState(() {}),
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage())),
            });
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
        future: SharedService.isLoggedIn(),
        builder: (BuildContext context, AsyncSnapshot<bool> loginModel) {
          if (loginModel.hasData) {
            if (loginModel.data) {
              return _listView(context);
            }
          } else {
            return UnAuthWidget();
          }
        });
  }

  Widget _buildRow(OptionsList optionsList, int index) {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(10),
          child: Icon(optionsList.optionIcon, size: 30),
        ),
        onTap: () {
          return optionsList.onTap();
        },
        title: new Text(
          optionsList.optionTitle,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 5),
          child: Text(
            optionsList.optionSubTitle,
            style: new TextStyle(color: Colors.redAccent, fontSize: 14),
          ),
        ),
        trailing: Icon(Icons.keyboard_arrow_right),
      ),
    );
  }

  Widget _listView(BuildContext context) {
    return new FutureBuilder(
        builder: (BuildContext context,
            AsyncSnapshot<LoginResponseModel> loginModel) {
          if (loginModel.hasData) {
            return ListView(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(15, 15, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome ,${loginModel.data.data.displayname}",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 0,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(16),
                        ),
                        child: _buildRow(options[index], index),
                      );
                    },
                    itemCount: options.length,
                    physics: ScrollPhysics(),
                    padding: EdgeInsets.all(8),
                    shrinkWrap: true),
              ],
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
        future: SharedService.loginDetails());
  }
}
