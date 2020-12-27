import 'package:cafe_yoga/provider/razor_payment_service.dart';
import 'package:flutter/cupertino.dart';

class PaymentMethod {
  String id;
  String name;
  String description;
  String logo;
  String route;
  Function onTap;
  bool isRouteRedirect;

  PaymentMethod({
    this.id,
    this.name,
    this.description,
    this.logo,
    this.route,
    this.onTap,
    this.isRouteRedirect,
  });
}

class PaymentMethodList {
  List<PaymentMethod> _paymentsList;
  List<PaymentMethod> _cashList;
  PaymentMethodList(BuildContext context) {
    this._paymentsList = [
      new PaymentMethod(
          id: "razorpay",
          name: "Razor Pay",
          description: "Click to pay with RazorPay method",
          logo: "assets/img/razorpay.png",
          route: "/RazorPay",
          onTap: () {
            RazorPaymentService razorPaymentService = new RazorPaymentService();
            razorPaymentService.initPaymentGateway();
            razorPaymentService.getPayment(context);
          },
          isRouteRedirect: false),
      new PaymentMethod(
          id: "paypal",
          name: "PayPal",
          description: "Click to pay with Paypal method",
          logo: "assets/img/paypal.png",
          route: "/PayPal",
          onTap: () {},
          isRouteRedirect: true),
    ];
    this._cashList = [
      new PaymentMethod(
          id: "cod",
          name: "Cash on Delivery",
          description: "Click to pay cash on delivery",
          logo: "assets/img/cash.png",
          route: "/OrderSuccess",
          onTap: () {},
          isRouteRedirect: true),
    ];
  }

  List<PaymentMethod> get paymentsList => _paymentsList;
  List<PaymentMethod> get cashList => _cashList;
}
