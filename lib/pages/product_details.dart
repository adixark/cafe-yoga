import 'package:cafe_yoga/Models/product.dart';
import 'package:cafe_yoga/pages/base_page.dart';
import 'package:cafe_yoga/widgets/widget_product_detail.dart';
import 'package:flutter/material.dart';

class ProductDetail extends BasePage {
  ProductDetail({Key key, this.product}) : super(key: key);

  Product product;

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends BasePageState<ProductDetail> {
  @override
  Widget pageUI() {
    return ProductDetailWidget(
      data: this.widget.product,
    );
  }
}
