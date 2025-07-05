import 'dart:developer';

import 'package:dio/dio.dart';

class ProductRemoteService {
  final String _fakeStoreApi = "https://fakestoreapi.com/";

  final dio = Dio();

  //Fetch products from Fake Store API
  Future<Response<dynamic>> fetchProducts() async {
    log("Fetching products from API");
    try {
      var response = await dio.get("${_fakeStoreApi}products");
      log("Products fetched successfully");
      return response;
    } catch (e) {
      log('Error fetching products: $e');
      throw Exception('Failed to fetch products');
    }
  }

  //Fetch all products from Fake Store API (for client-side pagination)
  Future<Response<dynamic>> fetchAllProducts() async {
    log("Fetching all products from API");
    try {
      var response = await dio.get("${_fakeStoreApi}products");
      log("All products fetched successfully");
      return response;
    } catch (e) {
      log('Error fetching all products: $e');
      throw Exception('Failed to fetch all products');
    }
  }
}
