import 'package:cafe_yoga/Models/cart_request_model.dart';
import 'package:cafe_yoga/Models/product.dart';
import 'package:cafe_yoga/Models/variable_product.dart';
import 'package:cafe_yoga/provider/cart_provider.dart';
import 'package:cafe_yoga/provider/loader_provider.dart';
import 'package:cafe_yoga/utils/cutom_stepper.dart';
import 'package:cafe_yoga/utils/expand_text.dart';
import 'package:cafe_yoga/widgets/widget_related_product.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailWidget extends StatelessWidget {
  ProductDetailWidget({Key key, this.data, this.variableProduct})
      : super(key: key);
  int quantity = 0;

  CartProducts cartProducts = new CartProducts();

  Product data;
  List<VariableProduct> variableProduct;
  final CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    print(this.data.relatedIds);
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                productImages(data.images, context),
                SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: data.calculateDiscount() > 0,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(color: Colors.green),
                      child: Text(
                        "${data.calculateDiscount()}% OFF ",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  data.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: data.type != "variable",
                      child: Text(
                        data.attributes != null && data.attributes.length > 0
                            ? (data.attributes[0].options.join("-").toString() +
                                "" +
                                data.attributes[0].name)
                            : "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Visibility(
                        visible: data.type == "variable",
                        child: selectDropdown(
                            context, variableProduct, this.variableProduct,
                            (VariableProduct value) {
                          this.data.price = value.price;
                          this.data.variableProduct = value;
                        })),
                    Row(
                      children: [
                        Text(
                          '₹ ${data.price}',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          '${data.regularPrice}',
                          style: TextStyle(
                            fontSize: 15,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomStepper(
                      lowerLimit: 0,
                      upperLimit: 20,
                      iconSize: 22,
                      stepValue: 1,
                      value: this.quantity,
                      onChanged: (value) {
                        cartProducts.quantity = value;
                      },
                    ),
                    FlatButton(
                      onPressed: () {
                        Provider.of<LoaderProvider>(context, listen: false)
                            .setLoadingStatus(true);
                        var cartProvider =
                            Provider.of<CartProvider>(context, listen: false);

                        cartProducts.productId = data.id;
                        cartProducts.variationId = data.variableProduct != null
                            ? data.variableProduct.id
                            : 0;
                        cartProvider.addToCart(cartProducts, (val) {
                          Provider.of<LoaderProvider>(context, listen: false)
                              .setLoadingStatus(false);
                          print(val);
                        });
                      },
                      child: Text(
                        "Add to Cart",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.redAccent,
                      padding: EdgeInsets.all(15),
                      shape: StadiumBorder(),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                ExpandText(
                  labelHeader: "Product Details",
                  shortDesc: data.shortDescription,
                  desc: data.description,
                ),
                Divider(),
                SizedBox(
                  height: 30,
                ),
                this.data.relatedIds.isEmpty
                    ? Container(
                        child: null,
                      )
                    : WidgetRelatedProducts(
                        labelName: "Related Products",
                        products: this.data.relatedIds,
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget productImages(List<Images> images, BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 250,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: CarouselSlider.builder(
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Container(
                  child: Center(
                    child: Image.network(
                      images[index].src,
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                autoPlay: false,
                enlargeCenterPage: true,
                viewportFraction: 1,
              ),
              carouselController: carouselController,
            ),
          ),
          Positioned(
            top: 100,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                carouselController.previousPage();
              },
            ),
          ),
          Positioned(
            top: 100,
            left: MediaQuery.of(context).size.width - 80,
            child: IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () {
                carouselController.nextPage();
              },
            ),
          ),
        ],
      ),
    );
  }

  static Widget selectDropdown(BuildContext context, Object initialValue,
      dynamic data, Function onchanged,
      {Function onValidate}) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        height: 75,
        width: 100,
        padding: EdgeInsets.only(top: 5),
        child: new DropdownButtonFormField<VariableProduct>(
            hint: new Text("Select"),
            decoration: fieldDecoration(
              context: context,
            ),
            value: null,
            //todo: this dropdown value needs to be fixed
            isDense: true,
            items: data != null
                ? data.map<DropdownMenuItem<VariableProduct>>(
                    (VariableProduct data) {
                    return DropdownMenuItem<VariableProduct>(
                      value: data,
                      child: new Text(
                        data.attributes.first.option +
                            " " +
                            data.attributes.first.name,
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList()
                : null,
            onChanged: (VariableProduct newValue) {
              FocusScope.of(context).requestFocus(new FocusNode());
              onchanged(newValue);
            }),
      ),
    );
  }

  static InputDecoration fieldDecoration({
    BuildContext context,
    String hintText,
    String helperText,
    Widget prefixIcon,
    Widget suffixIcon,
  }) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(6),
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1,
        ),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1,
        ),
      ),
    );
  }
}
