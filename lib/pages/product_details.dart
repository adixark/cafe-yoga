import 'package:cafe_yoga/Models/product.dart';
import 'package:cafe_yoga/Models/variable_product.dart';
import 'package:cafe_yoga/pages/base_page.dart';
import 'package:cafe_yoga/utils/api_services.dart';
import 'package:cafe_yoga/widgets/widget_product_detail.dart';
import 'package:flutter/material.dart';

class ProductDetail extends BasePage {
  ProductDetail({Key key, this.product}) : super(key: key);

  Product product;

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends BasePageState<ProductDetail> {
  APIService _apiService;
  @override
  Widget pageUI() {
    return this.widget.product.type == "variable"
        ? _variableProductList()
        : ProductDetailWidget(
            data: this.widget.product,
          );
  }

  Widget _variableProductList() {
    _apiService = new APIService();
    return new FutureBuilder(
      future: _apiService.getVariableProducts(this.widget.product.id),
      builder:
          (BuildContext context, AsyncSnapshot<List<VariableProduct>> model) {
        if (model.hasData) {
          return ProductDetailWidget(
            data: this.widget.product,
            variableProduct: model.data,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
