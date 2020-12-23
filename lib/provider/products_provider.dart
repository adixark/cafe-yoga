import 'package:flutter/cupertino.dart';

import 'package:cafe_yoga/Models/product.dart';
import 'package:cafe_yoga/api_services.dart';

class SortBy {
  String value;
  String text;
  String sortOrder;

  SortBy(
    this.value,
    this.text,
    this.sortOrder,
  );
}

enum LoadMoreStatus { INITIAL, LOADING, STABLE }

class ProductProvider with ChangeNotifier {
  APIService _apiService;
  List<Product> _productList;
  SortBy _sortBy;

  int pagesSize = 10;

  List<Product> get allProducts => _productList;
  double get totalRecords => _productList.length.toDouble();

  LoadMoreStatus _loadMoreStatus = LoadMoreStatus.STABLE;

  getLoadMoreStatus() => _loadMoreStatus;

  ProductProvider() {
    resetStrems();
    _sortBy = SortBy("modified", "Latest", "asc");
  }

  void resetStrems() {
    _apiService = new APIService();
    _productList = List<Product>();
  }

  setLoadingState(LoadMoreStatus loadMoreStatus) {
    _loadMoreStatus = loadMoreStatus;
    notifyListeners();
  }

  setSortOrder(SortBy sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }

  fetchProducts(
    pageNumber, {
    String strSearch,
    String tagName,
    String categoryId,
    String sortBy,
    String sortOrder = "asc",
  }) async {
    List<Product> itemModel = await _apiService.getProducts(
        strSearch: strSearch,
        tagName: tagName,
        pageNumber: pageNumber,
        pageSize: this.pagesSize,
        categoryId: categoryId,
        sortBy: this._sortBy.value,
        sortOrder: this._sortBy.sortOrder);

    if (itemModel.length > 0) {
      _productList.addAll(itemModel);
    }
    setLoadingState(LoadMoreStatus.STABLE);
    notifyListeners();
  }
}
