import 'dart:convert';
import 'dart:io';
import 'package:cafe_yoga/Models/category.dart' as categoryModel;
import 'package:cafe_yoga/Models/customer.dart';
import 'package:cafe_yoga/Models/product.dart';
import 'package:cafe_yoga/config.dart';
import 'package:dio/dio.dart';
import 'Models/login_model.dart';

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

  Future<List<Product>> getProducts(String tagId) async {
    List<Product> data = new List<Product>();

    try {
      String url = Config.url +
          Config.productsUrl +
          "?consumer_key=${Config.key}&consumer_secret=${Config.secret}&tag=$tagId";
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
              (i) => Product.fromJson(i),
            )
            .toList();
      }
    } on DioError catch (e) {
      print(e.response);
    }

    return data;
  }
}
