import 'dart:convert';
import 'dart:io';
import 'package:cafe_yoga/Models/cart_request_model.dart';
import 'package:cafe_yoga/Models/cart_response_model.dart';
import 'package:cafe_yoga/Models/category.dart' as categoryModel;
import 'package:cafe_yoga/Models/customer.dart';
import 'package:cafe_yoga/Models/customer_details_model.dart';
import 'package:cafe_yoga/Models/order.dart';
import 'package:cafe_yoga/Models/order_detail_model.dart';
import 'package:cafe_yoga/Models/product.dart';
import 'package:cafe_yoga/Models/variable_product.dart';
import 'package:cafe_yoga/config.dart';
import 'package:cafe_yoga/shared_service.dart';
import 'package:dio/dio.dart';
import '../Models/login_model.dart';

class APIService {
  Future<bool> createCustomer(CustomerModel model) async {
    var authToken = base64Encode(utf8.encode("${Config.key}:${Config.secret}"));

    bool ret = false;
    try {
      var response = await Dio().post(Config.url + Config.customerUrl,
          data: model.toJson(),
          options: new Options(headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.contentTypeHeader: "application/json"
          }));
      print(response);
      if (response.statusCode == 201) {
        ret = true;
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 404) {
        ret = false;
      } else {
        ret = false;
      }
    }

    return ret;
  }

  Future<LoginResponseModel> loginCustomer(
      String username, String password) async {
    LoginResponseModel model;

    try {
      var response = await Dio().post(
        Config.tokenUrl,
        data: {
          "username": username,
          "password": password,
        },
        options: new Options(headers: {
          HttpHeaders.contentTypeHeader: "application/x-www.form-urlencoded",
        }),
      );
      print(response);
      if (response.statusCode == 200) {
        model = LoginResponseModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      print(e.message);
    }
    return model;
  }

  Future<List<categoryModel.Category>> getCategories() async {
    List<categoryModel.Category> data = new List<categoryModel.Category>();

    try {
      String url = Config.url +
          Config.categoriesUrl +
          "?consumer_key=${Config.key}&consumer_secret=${Config.secret}";
      var response = await Dio().get(
        url,
        options: new Options(
          headers: {HttpHeaders.contentTypeHeader: "application/json"},
        ),
      );
      print(response);
      if (response.statusCode == 200) {
        data = (response.data as List)
            .map(
              (i) => categoryModel.Category.fromJson(i),
            )
            .toList();
      }
    } on DioError catch (e) {
      print(e.response);
    }

    return data;
  }

  Future<List<Product>> getProducts({
    int pageNumber,
    int pageSize,
    String strSearch,
    String tagName,
    String categoryId,
    String sortBy,
    List<int> productsIds,
    String sortOrder = "asc",
  }) async {
    List<Product> data = new List<Product>();

    try {
      String parameter = "";
      if (strSearch != null) {
        parameter += "&search=$strSearch";
      }
      if (pageSize != null) {
        parameter += "&per_page=$pageSize";
      }
      if (pageNumber != null) {
        parameter += "&page=$pageNumber";
      }
      if (tagName != null) {
        parameter += "&tag=$tagName";
      }
      if (categoryId != null) {
        parameter += "&category=$categoryId";
      }
      if (sortBy != null) {
        parameter += "&orderby=$sortBy";
      }
      if (sortOrder != null) {
        parameter += "&order=$sortOrder";
      }
      if (productsIds != null) {
        parameter += "&include=${productsIds.join(",").toString()}";
      }

      String url = Config.url +
          Config.productsUrl +
          "?consumer_key=${Config.key}&consumer_secret=${Config.secret}${parameter.toString()}";
      print(url);
      var response = await Dio().get(
        url,
        options: new Options(
          headers: {HttpHeaders.contentTypeHeader: "application/json"},
        ),
      );
      if (response.statusCode == 200) {
        data = (response.data as List)
            .map(
              (i) => Product.fromJson(i),
            )
            .toList();
      }
    } on DioError catch (e) {
      print(e.response);
    }

    return data;
  }

  Future<CartResponseModel> addtoCart(CartRequestModel model) async {
    model.userId = int.parse(Config.userID);

    LoginResponseModel loginResponseModel = await SharedService.loginDetails();

    if (loginResponseModel.data != null) {
      model.userId = loginResponseModel.data.id;
    }

    CartResponseModel responseModel;

    try {
      var response = await Dio().post(
        Config.url + Config.addtoCartUrl,
        data: model.toJson(),
        options: new Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        responseModel = CartResponseModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 404) {
        print(e.response.statusCode);
      } else {
        print(e.message);
        print(e.request);
      }
    }
    return responseModel;
  }

  Future<CartResponseModel> getCartItems() async {
    CartResponseModel responseModel;

    try {
      LoginResponseModel loginResponseModel =
          await SharedService.loginDetails();

      if (loginResponseModel.data != null) {
        int userId = loginResponseModel.data.id;

        String url = Config.url +
            Config.cartUrl +
            "?user_id=$userId&consumer_key=${Config.key}&consumer_secret=${Config.secret}";
        print(url);
        var response = await Dio().get(url,
            options: new Options(
                headers: {HttpHeaders.contentTypeHeader: "application/json"}));
        if (response.statusCode == 200) {
          responseModel = CartResponseModel.fromJson(response.data);
        }
      }
    } on DioError catch (e) {
      print(e.response);
    }
    return responseModel;
  }

  Future<List<VariableProduct>> getVariableProducts(int productId) async {
    List<VariableProduct> responseModel;

    try {
      String url = Config.url +
          Config.productsUrl +
          "/${productId.toString()}/${Config.variableProductsUrl}?consumer_key=${Config.key}&consumer_secret=${Config.secret}";
      var response = await Dio().get(
        url,
        options: new Options(
          headers: {HttpHeaders.contentTypeHeader: "application/json"},
        ),
      );
      if (response.statusCode == 200) {
        responseModel = (response.data as List)
            .map((e) => VariableProduct.fromJson(e))
            .toList();
      }
    } on DioError catch (e) {
      print(e.response);
    }
    return responseModel;
  }

  Future<CustomerDetailsModel> customerDetails() async {
    CustomerDetailsModel responseModel;
    try {
      LoginResponseModel loginResponseModel =
          await SharedService.loginDetails();

      if (loginResponseModel.data != null) {
        int userId = loginResponseModel.data.id;
        String url = Config.url +
            Config.customerUrl +
            "/$userId?consumer_key=${Config.key}&consumer_secret=${Config.secret}";
        var response = await Dio().get(url,
            options: new Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }));
        if (response.statusCode == 200) {
          responseModel = CustomerDetailsModel.fromJson(response.data);
        }
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 404) {
        print(e.response.statusCode);
      } else {
        print(e.message);
        print(e.request);
      }
    }
    return responseModel;
  }

  Future<bool> createOrder(OrderModel model) async {
    model.customerId = int.parse(Config.userID);
    //TODO: Changed same code here

    bool isOrderCreated = false;
    var authToken =
        base64.encode(utf8.encode(Config.key + ":" + Config.secret));
    try {
      var response = await Dio().post(
        Config.url + Config.orderUrl,
        data: model.toJson(),
        options: new Options(
          headers: {
            HttpHeaders.authorizationHeader: "Basic $authToken",
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );
      if (response.statusCode == 201) {
        isOrderCreated = true;
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 404) {
        print(e.response.statusCode);
      } else {
        print(e.message);
        print(e.request);
      }
    }
    return isOrderCreated;
  }

  Future<List<OrderModel>> getOrders() async {
    List<OrderModel> data = new List<OrderModel>();

    try {
      String url = Config.url +
          Config.orderUrl +
          "?consumer_key=${Config.key}&consumer_secret=${Config.secret}";
      print(url);

      var response = await Dio().get(
        url,
        options: new Options(
          headers: {HttpHeaders.contentTypeHeader: "application/json"},
        ),
      );
      if (response.statusCode == 200) {
        data = (response.data as List)
            .map(
              (e) => OrderModel.fromJson(e),
            )
            .toList();
      }
    } on DioError catch (e) {
      print(e.response);
    }
    return data;
  }

  Future<OrderDetailModel> getOrderDetails(int orderId) async {
    OrderDetailModel responseModel = new OrderDetailModel();
    try {
      String url = Config.url +
          Config.orderUrl +
          "/$orderId?consumer_key=${Config.key}&consumer_secret=${Config.secret}";
      print(url);

      var response = await Dio().get(url,
          options: new Options(
            headers: {
              HttpHeaders.authorizationHeader: "application/json",
            },
          ));
      if (response.statusCode == 200) {
        responseModel = OrderDetailModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      print(e.response);
    }
    return responseModel;
  }
}
