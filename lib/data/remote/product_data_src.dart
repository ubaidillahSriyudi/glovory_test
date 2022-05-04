import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glovory_test/core/error/exception.dart';
import 'package:glovory_test/core/utils/const.dart';
import 'package:glovory_test/data/models/category_model.dart';
import 'package:glovory_test/data/models/product_model.dart';

final productDataSrcProvider = Provider((ref) => ProductDataSources());

class ProductDataSources {
   final Dio _dio = Dio();
  
   Future<ProductModel> allProducts() async {
    try {
      const _url = '$baseUrl/api/v1/products/';
      final _options = Options(
        headers: {
          'X-Api-Key' : apiKey
        }
      );
      final _res = await _dio.get(_url, options: _options);
      final _value = json.decode(json.encode(_res.data));
      // print('allProducts $_value');
      return ProductModel.fromJson(_value);
    } on DioError catch (e) {
      throw const ServerException(message: 'Data Failed');
    }
  }

   Future<ProductModel> pagination(int page) async {
    try {
      final _url = '$baseUrl/api/v1/products/?page=$page';
      final _options = Options(
        headers: {
          'X-Api-Key' : apiKey
        }
      );
      final _res = await _dio.get(_url, options: _options);
      final _value = json.decode(json.encode(_res.data));
      return ProductModel.fromJson(_value);
    } on DioError catch (e) {
      // throw const ServerException(message: 'Data Failed');
      return ProductModel();
    }
  }

  Future<ProductModel> productByCategory(String category) async {
    try {
      final _url = '$baseUrl/api/v1/products/?product_category=$category';
      final _options = Options(
        headers: {
          'X-Api-Key' : apiKey
        }
      );
      final _res = await _dio.get(_url, options: _options);
      final _value = json.decode(json.encode(_res.data));
      // print('allProducts $_value');
      return ProductModel.fromJson(_value);
    } on DioError catch (e) {
      throw const ServerException(message: 'Data Failed');
    }
  }

  Future<ProductModel> search(String nameProducts) async {
    try {
      final _url = '$baseUrl/api/v1/products/?search=$nameProducts';
      final _options = Options(
        headers: {
          'X-Api-Key' : apiKey
        }
      );
      final _res = await _dio.get(_url, options: _options);
      final _value = json.decode(json.encode(_res.data));
      return ProductModel.fromJson(_value);
    } on DioError catch (e) {
      throw const ServerException(message: 'Data Failed');
    }
  }

   Future<CategoryModel> categories({bool paging = false, int page = 0}) async {
    try {
      const _url = '$baseUrl/api/v1/category/';
      final _urlPaging = '$baseUrl/api/v1/category/?page$page';
      final _options = Options(
        headers: {
          'X-Api-Key' : apiKey
        }
      );
      final _res = await _dio.get(paging == true ? _url : _urlPaging, options: _options);
      final _value = json.decode(json.encode(_res.data));
      return CategoryModel.fromJson(_value);
    } on DioError catch (e) {
      throw const ServerException(message: 'Data Failed');
    }
  }
}