import 'dart:developer';

import 'package:ecommerce/feature/home/data/model/product_model.dart';
import 'package:ecommerce/feature/home/data/service/remote/product_remote.dart';

class ProductRepo {
  final ProductRemoteService _productRemoteService;

  ProductRepo(
    this._productRemoteService,
  );

  Future<List<ProductModel>> fetchProducts() async {
    try {
      var response = await _productRemoteService.fetchProducts();

      if (response.statusCode == 200) {
        log('Products fetched successfully');

        final List<dynamic> productsData = response.data as List<dynamic>;

        List<ProductModel> products = productsData
            .map((productJson) =>
                ProductModel.fromMap(productJson as Map<String, dynamic>))
            .toList();

        return products;
      } else {
        log('Failed to fetch products with status code: ${response.statusCode}');
        throw Exception('Failed to fetch products');
      }
    } catch (e) {
      log('Error fetching products: $e');
      throw Exception('Failed to fetch products');
    }
  }
}
