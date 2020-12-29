import 'dart:convert';
import 'dart:io';

import 'package:cafe_yoga/Models/cart_response_model.dart';
import 'package:cafe_yoga/config.dart';
import 'package:cafe_yoga/provider/cart_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;

class PaypalService {
  String clientId = Config.paypalClienId;
  String secret = Config.paypalSecretKey;

  String returnUrl = "return.cafe-yoga.com";
  String cancelUrl = "cancel.cafe-yoga.com";

/*
    Below Method is to generate the AcessToken from PayPal
 */

  Future<String> getAccessToken() async {
    try {
      var authToken = base64.encode(utf8.encode(clientId + ":" + secret));
      var response = await Dio().post(
          "${Config.paypalUrl}/v1/oauth2/token?grant_type=client_credentials",
          options: new Options(
            headers: {
              HttpHeaders.authorizationHeader: 'Basis $authToken',
              HttpHeaders.contentTypeHeader: "application/json",
            },
          ));
      if (response.statusCode == 200) {
        final body = response.data;
        return body["access_token"];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

// You can Change default currency according to your need
  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "INR",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": "INR"
  };

  Map<String, dynamic> getOrderParams(BuildContext context) {
    var cartModel = Provider.of<CartProvider>(context, listen: false);
    cartModel.fetchCartitem();

    List items = [];
    cartModel.cartItems.forEach((CartItem item) {
      items.add({
        "name": item.productName,
        "quantity": item.qty,
        "price": item.productSalePrice,
        "currency": defaultCurrency["currency"],
      });
    });

    String totalAmount = cartModel.totalAmount.toString();
    String subtotalAmount = cartModel.totalAmount.toString();
    String shippingCost = "0";
    int shippingDiscount = 0;

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": totalAmount,
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": subtotalAmount,
              "shipping": shippingCost,
              "shipping_discount": ((-1.0) * shippingDiscount).toString(),
            }
          },
          "description": "The Payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {"items": items},
        }
      ],
      "note_to_payee": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnUrl, "cancel_url": cancelUrl}
    };
    return temp;
  }

  /*
      Below Method is use to Create Payment Request with Paypal
   */
  Future<Map<String, String>> createPaypalPayment(
      transactions, accessToken) async {
    try {
      var response = await Dio().post(
        "${Config.paypalUrl}/v1/payments/payment",
        data: convert.jsonEncode(transactions),
        options: new Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken',
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );
      final body = response.data;
      if (response.statusCode == 201) {
        if (body["links"] != null && body["links"].length > 0) {
          List links = body["links"];

          String executeUrl = "";
          String approvalUrl = "";
          final items = links.firstWhere(
              (element) => element["rel"] == "approval_url",
              orElse: () => null);
          if (items != null) {
            approvalUrl = items["href"];
          }
          final items1 = links.firstWhere(
              (element) => element["rel"] == "approval_url",
              orElse: () => null);
          if (items1 != null) {
            executeUrl = items1["href"];
          }
          return {"executeUrl": executeUrl, "approvalUrl": approvalUrl};
        }
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  /*
  Below method is use to executing Payment transactions
   */
  Future<String> executePayment(url, payerId, accessToken) async {
    try {
      var response = await Dio().post(url,
          data: convert.jsonEncode({"payer_id": payerId}),
          options: new Options(headers: {
            HttpHeaders.authorizationHeader: "Bearer $accessToken",
            HttpHeaders.contentTypeHeader: "application/json",
          }));
      final body = response.data;
      if (response.statusCode == 200) {
        return body["id"];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
