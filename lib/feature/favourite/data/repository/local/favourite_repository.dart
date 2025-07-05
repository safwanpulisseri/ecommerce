import 'package:hive/hive.dart';
import 'package:ecommerce/feature/home/data/model/product_model.dart';

class FavoriteRepository {
  static const String _favoriteBoxName = 'favorites';
  Box<ProductModel>? _favoriteBox;

  Future<void> init() async {
    _favoriteBox = await Hive.openBox<ProductModel>(_favoriteBoxName);
  }

  List<ProductModel> get favoriteProducts {
    if (_favoriteBox == null) return [];
    return _favoriteBox!.values.toList();
  }

  Future<void> addToFavorites(ProductModel product) async {
    if (_favoriteBox == null) await init();
    await _favoriteBox!.put('product_${product.id}', product);
  }

  Future<void> removeFromFavorites(int productId) async {
    if (_favoriteBox == null) await init();
    await _favoriteBox!.delete('product_$productId');
  }

  Future<void> toggleFavorite(ProductModel product) async {
    if (_favoriteBox == null) await init();

    final key = 'product_${product.id}';
    if (_favoriteBox!.containsKey(key)) {
      await _favoriteBox!.delete(key);
    } else {
      await _favoriteBox!.put(key, product);
    }
  }

  Future<void> clearAllFavorites() async {
    if (_favoriteBox == null) await init();
    await _favoriteBox!.clear();
  }

  bool isFavorite(int productId) {
    if (_favoriteBox == null) return false;
    return _favoriteBox!.containsKey('product_$productId');
  }

  int get favoriteCount {
    if (_favoriteBox == null) return 0;
    return _favoriteBox!.length;
  }
}
