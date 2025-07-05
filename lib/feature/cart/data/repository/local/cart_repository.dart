import 'package:hive/hive.dart';
import 'package:ecommerce/feature/cart/data/model/cart_model.dart';
import 'package:ecommerce/feature/home/data/model/product_model.dart';

class CartRepository {
  static const String _cartBoxName = 'cart';
  Box<CartModel>? _cartBox;

  Future<void> init() async {
    _cartBox = await Hive.openBox<CartModel>(_cartBoxName);
  }

  List<CartModel> get cartItems {
    if (_cartBox == null) return [];
    return _cartBox!.values.toList();
  }

  Future<void> addToCart(ProductModel product, {int quantity = 1}) async {
    if (_cartBox == null) await init();

    final existingKey = _getProductKey(product.id);

    if (existingKey != null) {
      final existingItem = _cartBox!.get(existingKey);
      if (existingItem != null) {
        final updatedItem = existingItem.copyWith(
          quantity: existingItem.quantity + quantity,
        );
        await _cartBox!.put(existingKey, updatedItem);
      }
    } else {
      final cartItem = CartModel(product: product, quantity: quantity);
      await _cartBox!.put('product_${product.id}', cartItem);
    }
  }

  Future<void> removeFromCart(int productId) async {
    if (_cartBox == null) await init();

    final key = _getProductKey(productId);
    if (key != null) {
      await _cartBox!.delete(key);
    }
  }

  Future<void> updateQuantity(int productId, int newQuantity) async {
    if (_cartBox == null) await init();

    if (newQuantity <= 0) {
      await removeFromCart(productId);
      return;
    }

    final key = _getProductKey(productId);
    if (key != null) {
      final existingItem = _cartBox!.get(key);
      if (existingItem != null) {
        final updatedItem = existingItem.copyWith(quantity: newQuantity);
        await _cartBox!.put(key, updatedItem);
      }
    }
  }

  Future<void> clearCart() async {
    if (_cartBox == null) await init();
    await _cartBox!.clear();
  }

  double get totalAmount {
    return cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  int get totalItems {
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  bool isInCart(int productId) {
    return _getProductKey(productId) != null;
  }

  CartModel? getCartItem(int productId) {
    final key = _getProductKey(productId);
    if (key != null) {
      return _cartBox!.get(key);
    }
    return null;
  }

  String? _getProductKey(int productId) {
    if (_cartBox == null) return null;

    for (final key in _cartBox!.keys) {
      final item = _cartBox!.get(key);
      if (item != null && item.product.id == productId) {
        return key as String;
      }
    }
    return null;
  }
}
