import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:ecommerce/feature/home/data/model/product_model.dart';

part 'cart_model.g.dart';

@HiveType(typeId: 2)
class CartModel {
  @HiveField(0)
  final ProductModel product;
  @HiveField(1)
  int quantity;

  CartModel({
    required this.product,
    required this.quantity,
  });

  CartModel copyWith({
    ProductModel? product,
    int? quantity,
  }) {
    return CartModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'quantity': quantity,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      product: ProductModel.fromMap(map['product']),
      quantity: (map['quantity'] as num).toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory CartModel.fromJson(String source) =>
      CartModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CartModel(product: $product, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartModel &&
        other.product == product &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return product.hashCode ^ quantity.hashCode;
  }
}
