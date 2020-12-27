import 'package:cafe_yoga/provider/cart_provider.dart';
import 'package:cafe_yoga/provider/loader_provider.dart';
import 'package:cafe_yoga/utils/cutom_stepper.dart';
import 'package:cafe_yoga/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:cafe_yoga/Models/cart_response_model.dart';
import 'package:provider/provider.dart';

class CartProduct extends StatelessWidget {
  CartItem data;
  CartProduct({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: new EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: makeListTitle(context),
      ),
    );
  }

  ListTile makeListTitle(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        leading: Container(
          width: 50,
          height: 150,
          alignment: Alignment.center,
          child: Image.network(
            data.thumbnail,
            height: 150,
          ),
        ),
        title: Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            data.variationId == 0
                ? data.productName
                : "${data.productName} (${data.attributeValues}${data.attribute})",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.all(5),
          child: Wrap(
            direction: Axis.vertical,
            children: [
              Text(
                "₹ ${data.productSalePrice} per item",
                style: TextStyle(color: Colors.black),
              ),
              FlatButton(
                onPressed: () {
                  Utils.showMessage(
                      context,
                      "Cafe Yoga",
                      "Do you really want to remove this item from cart?",
                      "Yes",
                      () {
                        Provider.of<LoaderProvider>(context, listen: false)
                            .setLoadingStatus(true);

                        Provider.of<CartProvider>(context, listen: false)
                            .removeItem(data.productId);

                        //todo:implement update cart hereeeeeeeeeeeeeeeeee  if item remove then update it to the server

                        Provider.of<LoaderProvider>(context, listen: false)
                            .setLoadingStatus(true);

                        Provider.of<LoaderProvider>(context, listen: false)
                            .setLoadingStatus(false);
                        Navigator.of(context).pop();
                      },
                      buttonText2: "No",
                      onPressed2: () {
                        Navigator.of(context).pop();
                      },
                      isConfirmationDialog: true);
                },
                color: Colors.red,
                padding: EdgeInsets.all(8),
                shape: StadiumBorder(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 20,
                    ),
                    Text(
                      "Remove",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        trailing: Container(
          width: 120,
          child: CustomStepper(
            lowerLimit: 0,
            upperLimit: 20,
            iconSize: 22,
            stepValue: 1,
            value: data.qty,
            onChanged: (value) {
              Provider.of<CartProvider>(context, listen: false).updateqty(
                  data.productId, value,
                  variationId: data.variationId);
            },
          ),
        ),
      );
}
