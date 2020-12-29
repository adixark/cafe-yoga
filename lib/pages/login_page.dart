import 'package:cafe_yoga/pages/home_page.dart';
import 'package:cafe_yoga/shared_service.dart';
import 'package:cafe_yoga/utils/form_helper.dart';
import 'package:cafe_yoga/utils/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:cafe_yoga/utils/api_services.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hidePassword = true;
  bool isApiCallProcess = false;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String username;
  String password;
  APIService apiService;

  @override
  void initState() {
    apiService = new APIService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).accentColor,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor,
                        boxShadow: [
                          BoxShadow(
                              color:
                                  Theme.of(context).hintColor.withOpacity(0.2),
                              offset: Offset(0, 10),
                              blurRadius: 20)
                        ]),
                    child: Form(
                      key: globalKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 25,
                          ),
                          Text("Login",
                              style: Theme.of(context).textTheme.headline2),
                          SizedBox(
                            height: 20,
                          ),
                          new TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (input) => {username = input},
                            validator: (input) => !input.contains("@")
                                ? "Email Id should be vaild"
                                : null,
                            decoration: new InputDecoration(
                                hintText: "Email Address",
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2),
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).accentColor),
                                ),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Theme.of(context).accentColor,
                                )),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          new TextFormField(
                            keyboardType: TextInputType.text,
                            onSaved: (input) => {password = input},
                            validator: (input) => input.length < 3
                                ? "Password should be more than 3 characters"
                                : null,
                            obscureText: hidePassword,
                            decoration: new InputDecoration(
                                hintText: "Password",
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.4),
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).accentColor),
                                ),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Theme.of(context).accentColor,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      hidePassword = !hidePassword;
                                    });
                                  },
                                  icon: Icon(hidePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                )),
                          ),
                          SizedBox(height: 30),
                          FlatButton(
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 80),
                            onPressed: () {
                              if (validateAndSave()) {
                                setState(() {
                                  isApiCallProcess = true;
                                });
                                apiService
                                    .loginCustomer(username, password)
                                    .then((ret) {
                                  setState(() {
                                    isApiCallProcess = false;
                                  });
                                  if (ret.success) {
                                    FormHelper.showMessage(context, "Welcome",
                                        "Login Successfull", "Ok", () {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomePage(
                                              selectedPage: 3,
                                            ),
                                          ),
                                          ModalRoute.withName("/Home"));
                                    });
                                    SharedService.setLoginDetails(ret);
                                  } else {
                                    FormHelper.showMessage(context, "Error",
                                        "Invalid Credentials", "Ok", () {
                                      Navigator.of(context).pop();
                                    });
                                  }
                                });
                              }
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Theme.of(context).accentColor,
                            shape: StadiumBorder(),
                          ),
                          SizedBox(
                            height: 25,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
