import 'package:cafe_yoga/provider/paypal_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PaypalPaymentScreen extends StatefulWidget {
  @override
  _PaypalPaymentScreenState createState() => _PaypalPaymentScreenState();
}

class _PaypalPaymentScreenState extends State<PaypalPaymentScreen> {
  InAppWebViewController webView;
  String url = "";
  double progress = 0;
  GlobalKey<ScaffoldState> scaffoldKey;
  String checkOutUrl;
  String executeUrl;
  String accessToken;

  PaypalService paypalService;

  @override
  void initState() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    paypalService = new PaypalService();

    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await paypalService.getAccessToken();
        final transactions = paypalService.getOrderParams(context);
        final res =
            await paypalService.createPaypalPayment(transactions, accessToken);
        if (res != null) {
          setState(() {
            checkOutUrl = res['approvalUrl'];
            executeUrl = res['executeUrl'];
          });
        }
      } catch (e) {
        print(e);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (checkOutUrl != null) {
      return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "PayPal Payment",
            style: Theme.of(context)
                .textTheme
                .headline6
                .merge(TextStyle(letterSpacing: 1.3)),
          ),
        ),
        body: Stack(
          children: [
            InAppWebView(
              initialUrl: checkOutUrl,
              initialOptions: new InAppWebViewGroupOptions(
                android: AndroidInAppWebViewOptions(textZoom: 120),
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                webView = controller;
              },
              onLoadStart:
                  (InAppWebViewController controller, String requestURL) async {
                if (requestURL.contains(paypalService.returnUrl)) {
                  final uri = Uri.parse(requestURL);
                  final payerId = uri.queryParameters['PayerID'];
                  if (payerId != null) {
                    await paypalService
                        .executePayment(url, payerId, accessToken)
                        .then((id) {
                      print(id);
                      Navigator.of(context).pop();
                    });
                  }
                } else {
                  Navigator.of(context).pop();
                }
                if (requestURL.contains(paypalService.cancelUrl)) {
                  Navigator.of(context).pop();
                }
              },
              onProgressChanged:
                  (InAppWebViewController controller, int progress) {
                setState(() {
                  this.progress = progress / 100;
                });
              },
            ),
            progress < 1
                ? SizedBox(
                    height: 3,
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor:
                          Theme.of(context).accentColor.withOpacity(0.2),
                    ))
                : SizedBox(),
          ],
        ),
      );
    } else {
      return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "PayPal Payment",
            style: Theme.of(context)
                .textTheme
                .headline6
                .merge(TextStyle(letterSpacing: 1.3)),
          ),
        ),
        body: Center(
          child: Container(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
  }
}
