import 'package:cafe_yoga/utils/api_services.dart';
import 'package:cafe_yoga/Models/customer.dart';
import 'package:cafe_yoga/utils/form_helper.dart';
import 'package:cafe_yoga/utils/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:cafe_yoga/utils/validator_service.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  APIService apiService;
  CustomerModel model;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool hidePassword = true;
  bool isApiCallProcess = false;

  @override
  void initState() {
    apiService = new APIService();
    model = new CustomerModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        automaticallyImplyLeading: true,
        title: Text("SignUp"),
      ),
      body: ProgressHUD(
        child: new Form(key: globalKey, child: formUI()),
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
      ),
    );
  }

  Widget formUI() {
    return SingleChildScrollView(
        child: Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormHelper.fieldLabel("First Name"),
                FormHelper.textInput(
                    context,
                    model.firstName,
                    (value) => {
                          this.model.firstName = value,
                        }, onValidate: (value) {
                  if (value.toString().isEmpty) {
                    return "Please Enter First Name";
                  }
                  return null;
                }),
                FormHelper.fieldLabel("Last Name"),
                FormHelper.textInput(
                    context,
                    model.lastName,
                    (value) => {
                          this.model.lastName = value,
                        }, onValidate: (value) {
                  return null;
                }),
                FormHelper.fieldLabel("Email Id"),
                FormHelper.textInput(
                    context,
                    model.email,
                    (value) => {
                          this.model.email = value,
                        }, onValidate: (value) {
                  if (value.toString().isEmpty) {
                    return "Please Enter email-id";
                  }
                  if (value.toString().isNotEmpty &&
                      !value.toString().isValidEmail()) {}
                  return null;
                }),
                FormHelper.fieldLabel("Password"),
                FormHelper.textInput(
                  context,
                  model.password,
                  (value) => {
                    this.model.password = value,
                  },
                  onValidate: (value) {
                    if (value.toString().isEmpty) {
                      return "Please enter password";
                    }
                    return null;
                  },
                  obscureText: hidePassword,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    color: Theme.of(context).accentColor.withOpacity(0.4),
                    icon: Icon(
                        hidePassword ? Icons.visibility_off : Icons.visibility),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                new Center(
                    child: FormHelper.saveButton("Register", () {
                  if (validateAndSave()) {
                    print(model.toJson());
                    setState(() {
                      isApiCallProcess = true;
                    });

                    apiService.createCustomer(model).then((ret) {
                      setState(() {
                        isApiCallProcess = false;
                      });

                      if (ret) {
                        FormHelper.showMessage(
                            context, "Welcome", "Registrarion Successful", "OK",
                            () {
                          Navigator.of(context).pop();
                        });
                      } else {
                        FormHelper.showMessage(
                            context, "Error", "Email already registred", "OK",
                            () {
                          Navigator.of(context).pop();
                        });
                      }
                    });
                  }
                }))
              ],
            )),
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
