import 'package:cafe_yoga/Models/order.dart';
import 'package:cafe_yoga/pages/base_page.dart';
import 'package:cafe_yoga/provider/order_provider.dart';
import 'package:cafe_yoga/widgets/widget_order_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersPage extends BasePage {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends BasePageState<OrdersPage> {
  List<OrderModel> orders;

  @override
  void initState() {
    super.initState();
    var orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.fetchOrder();
  }

  @override
  Widget pageUI() {
    return new Consumer<OrderProvider>(builder: (context, ordersModel, child) {
      if (ordersModel.allOrders != null && ordersModel.allOrders.length > 0) {
        _listView(context, ordersModel.allOrders);
      }
      return Center(
        child: CircularProgressIndicator(),
      );
    });
  }

  Widget _listView(BuildContext context, List<OrderModel> order) {
    return ListView(
      children: [
        ListView.builder(
          itemCount: order.length,
          physics: ScrollPhysics(),
          padding: EdgeInsets.all(8),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(16),
              ),
              child: OrderItem(
                orderModel: order[index],
              ),
            );
          },
        ),
      ],
    );
  }
}
