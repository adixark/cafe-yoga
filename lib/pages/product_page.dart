import 'dart:async';

import 'package:cafe_yoga/provider/products_provider.dart';
import 'package:flutter/material.dart';

import 'package:cafe_yoga/Models/product.dart';
import 'package:cafe_yoga/api_services.dart';
import 'package:cafe_yoga/pages/base_page.dart';
import 'package:cafe_yoga/widgets/widget_product_card.dart';
import 'package:provider/provider.dart';

class ProductPage extends BasePage {
  ProductPage({Key key, this.categoryId}) : super(key: key);
  int categoryId;

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends BasePageState<ProductPage> {
  int _page = 1;
  ScrollController _scrollController = new ScrollController();

  final _searchQuery = TextEditingController();
  Timer _debounce;

  final _sortByOptions = [
    SortBy("popularity", "Popularity", "asc"),
    SortBy("modified", "Latest", "asc"),
    SortBy("price", "Price: High to Low", "desc"),
    SortBy("price", "Price: Low to High", "asc"),
  ];

  @override
  void initState() {
    // TODO: implement initState

    var productList = Provider.of<ProductProvider>(context, listen: false);
    productList.resetStrems();
    productList.setLoadingState(LoadMoreStatus.INITIAL);
    productList.fetchProducts(_page,
        categoryId: this.widget.categoryId.toString());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        productList.setLoadingState(LoadMoreStatus.LOADING);
        productList.fetchProducts(++_page,
            categoryId: this.widget.categoryId.toString());
      }
    });

    _searchQuery.addListener(_onSearchChange);
    super.initState();
  }

  @override
  void dispose() {
    _searchQuery.removeListener(_onSearchChange);
    _searchQuery.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  _onSearchChange() {
    print("Changed");
    var productsList = Provider.of<ProductProvider>(context, listen: false);
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(Duration(milliseconds: 500), () {
      productsList.resetStrems();
      productsList.setLoadingState(LoadMoreStatus.INITIAL);
      productsList.fetchProducts(_page,
          strSearch: _searchQuery.text,
          categoryId: this.widget.categoryId.toString());
    });
  }

  @override
  Widget pageUI() {
    return _productList();
  }

  Widget _productList() {
    return new Consumer<ProductProvider>(
        builder: (context, productmodel, child) {
      if (productmodel.allProducts != null &&
          productmodel.allProducts.length > 0 &&
          productmodel.getLoadMoreStatus() != LoadMoreStatus.INITIAL) {
        return _buildList(productmodel.allProducts,
            productmodel.getLoadMoreStatus() == LoadMoreStatus.LOADING);
      }
      return Center(
        child: CircularProgressIndicator(),
      );
    });
  }

  Widget _buildList(List<Product> items, bool isLoadMore) {
    return Column(
      children: [
        _productFilter(),
        Flexible(
          child: GridView.count(
            crossAxisCount: 2,
            controller: _scrollController,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            children: items.map((Product item) {
              return ProductCard(
                data: item,
              );
            }).toList(),
          ),
        ),
        Visibility(
            visible: isLoadMore,
            child: Container(
              padding: EdgeInsets.all(5),
              height: 35,
              width: 35,
              child: CircularProgressIndicator(),
            ))
      ],
    );
  }

  Widget _productFilter() {
    return Container(
      height: 51,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _searchQuery,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                fillColor: Color(0xffe6e6ec),
                filled: true,
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xffe6e6ec),
              borderRadius: BorderRadius.circular(9),
            ),
            child: PopupMenuButton(
              onSelected: (sortBy) {
                var productList =
                    Provider.of<ProductProvider>(context, listen: false);
                productList.resetStrems();
                productList.setSortOrder(sortBy);
                productList.fetchProducts(_page,
                    categoryId: this.widget.categoryId.toString());
              },
              itemBuilder: (BuildContext context) {
                return _sortByOptions.map(
                  (item) {
                    return PopupMenuItem(
                      value: item,
                      child: Container(
                        child: Text(item.text),
                      ),
                    );
                  },
                ).toList();
              },
              icon: Icon(Icons.tune),
            ),
          )
        ],
      ),
    );
  }
}
