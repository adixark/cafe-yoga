import 'package:cafe_yoga/Models/customer_details_model.dart';

class OrderDetailModel {
  String paymentMethod;
  String transactionId;
  List<LineItems> lineItems;

  int orderId;
  String orderNumber;
  String orderStatus;
  DateTime orderDate;
  Shipping shipping;
  double totalAmount;
  double itemTotalAmount;
  double shippingTotal;

  OrderDetailModel({
    this.paymentMethod,
    this.transactionId,
    this.lineItems,
    this.orderId,
    this.orderNumber,
    this.orderStatus,
    this.orderDate,
    this.shipping,
    this.totalAmount,
    this.itemTotalAmount,
    this.shippingTotal,
  });

  OrderDetailModel.fromJson(Map<String, dynamic> json) {
    orderId = json['id'];
    orderStatus = json['status'];
    orderNumber = json['order_key'];
    orderDate = DateTime.parse(json['date_created']);
    paymentMethod = json['payment_method_title'];
    // shipping = json['shipping'] !=null ? new Shipping.fromJson(json['shipping]): null;

    if (json['line_item'] != null) {
      lineItems = new List<LineItems>();
      json['line_items'].forEach((e) {
        lineItems.add(new LineItems.fromJson(e));
      });

      totalAmount = lineItems != null
          ? lineItems.map<double>((e) => e.totalAmount).reduce((a, b) => a + b)
          : 0;
    }
    totalAmount = double.parse(json['total']);
    shippingTotal = double.parse(json['shipping_total']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['payment_method'] = paymentMethod;
    data['transaction_id'] = transactionId;
    data['shipping'] = shipping.toJson();

    if (lineItems != null) {
      data['line_items'] = lineItems.map((e) => e.toJson()).toList();
    }

    return data;
  }
}

class LineItems {
  int productId;
  String productName;
  int quantity;
  int variationId;
  double totalAmount;

  LineItems(
      {this.productId,
      this.productName,
      this.quantity,
      this.totalAmount,
      this.variationId});

  LineItems.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['name'];
    variationId = json['variation_id'];
    quantity = json['quantity'];
    totalAmount = double.parse(json['total']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    if (this.variationId != null) {
      data['variation_id'] = this.variationId;
    }
    return data;
  }
}
