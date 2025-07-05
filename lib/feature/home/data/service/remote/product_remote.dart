import 'dart:developer';

import 'package:dio/dio.dart';

class ProductRemoteService {
  final String _fakeStoreApi = "https://fakestoreapi.com/";

  final dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
  ));

  //Fetch products from Fake Store API
  Future<Response<dynamic>> fetchProducts() async {
    log("Fetching products from API: ${_fakeStoreApi}products");
    try {
      var response = await dio.get("${_fakeStoreApi}products");
      log("Products fetched successfully - Status: ${response.statusCode}, Data length: ${response.data?.length}");
      return response;
    } catch (e) {
      if (e is DioException) {
        log('DioException - Type: ${e.type}, Message: ${e.message}, Status: ${e.response?.statusCode}');
        log('Request URL: ${e.requestOptions.uri}');
        if (e.response != null) {
          log('Response data: ${e.response?.data}');
        }
      } else {
        log('Generic error fetching products: $e');
      }
      throw Exception('Failed to fetch products: ${e.toString()}');
    }
  }

  //Fetch all products from Fake Store API (for client-side pagination)
  Future<Response<dynamic>> fetchAllProducts() async {
    log("Fetching all products from API: ${_fakeStoreApi}products");
    try {
      var response = await dio.get("${_fakeStoreApi}products");
      log("All products fetched successfully - Status: ${response.statusCode}, Data length: ${response.data?.length}");
      return response;
    } catch (e) {
      if (e is DioException) {
        log('DioException - Type: ${e.type}, Message: ${e.message}, Status: ${e.response?.statusCode}');
        log('Request URL: ${e.requestOptions.uri}');
        if (e.response != null) {
          log('Response data: ${e.response?.data}');
        }
      } else {
        log('Generic error fetching all products: $e');
      }
      throw Exception('Failed to fetch all products: ${e.toString()}');
    }
  }
}
