import 'package:cafe_yoga/Models/cart_request_model.dart';
import 'package:cafe_yoga/Models/cart_response_model.dart';
import 'package:cafe_yoga/utils/api_services.dart';
import 'package:flutter/cupertino.dart';

class CartProvider with ChangeNotifier {
  APIService _apiService;
  List<CartItem> _cartItems;

  List<CartItem> get cartItems => _cartItems;
  double get totalRecords => _cartItems.length.toDouble();

  double get totalAmount => _cartItems != null
      ? _cartItems
          .map<double>((e) => e.lineSubtotal)
          .reduce((value, element) => value + element)
      : 0;

  CartProvider() {
    _apiService = new APIService();
    _cartItems = new List<CartItem>();
  }

  void resetStreams() {
    _apiService = new APIService();
    _cartItems = new List<CartItem>();
  }

  void addToCart(
    CartProducts product,
    Function onCallback,
  ) async {
    CartRequestModel requestModel = new CartRequestModel();
    requestModel.products = new List<CartProducts>();
    if (_cartItems == null) {
      await fetchCartitem();
    }

    _cartItems.forEach((element) {
      requestModel.products.add(new CartProducts(
          productId: element.productId,
          quantity: element.qty,
          variationId: element.variationId));
    });

    var isProductExist = requestModel.products.firstWhere(
        (prd) =>
            prd.productId == product.productId &&
            prd.variationId == product.variationId,
        orElse: () => null);

    if (isProductExist != null) {
      requestModel.products.remove(isProductExist);
    }
    requestModel.products.add(product);

    await _apiService.addtoCart(requestModel).then((cartResponseModel) {
      if (cartResponseModel.data != null) {
        _cartItems = [];
        _cartItems.addAll(cartResponseModel.data);
      }

      onCallback(cartResponseModel);
      notifyListeners();
    });
  }

  fetchCartitem() async {
    if (_cartItems == null) {
      resetStreams();
    }
    await _apiService.getCartItems().then((cartResponseModel) {
      if (cartResponseModel.data != null) {
        _cartItems.addAll(cartResponseModel.data);
      }
      notifyListeners();
    });
  }

  void updateqty(int productId, int qty, {int variationId = 0}) {
    var isProductExist = _cartItems.firstWhere(
        (prd) => prd.productId == productId && prd.variationId == variationId,
        orElse: () => null);
    if (isProductExist != null) {
      isProductExist.qty = qty;
    }
    notifyListeners();
  }

  void updateCart(Function onCallback) async {
    CartRequestModel requestModel = new CartRequestModel();
    requestModel.products = new List<CartProducts>();
    if (_cartItems == null) {
      resetStreams();
    }

    _cartItems.forEach((element) {
      requestModel.products.add(new CartProducts(
          productId: element.productId,
          quantity: element.qty,
          variationId: element.variationId));
    });

    await _apiService.addtoCart(requestModel).then((cartResponseModel) {
      if (cartResponseModel.data != null) {
        _cartItems = [];
        _cartItems.addAll(cartResponseModel.data);
      }

      onCallback(cartResponseModel);
      notifyListeners();
    });
  }

  void removeItem(int productId) {
    var isProductExist = _cartItems
        .firstWhere((prd) => prd.productId == productId, orElse: () => null);
    if (isProductExist != null) {
      _cartItems.remove(isProductExist);
    }
    notifyListeners();
  }
}
