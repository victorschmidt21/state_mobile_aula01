import 'package:flutter/foundation.dart';
import '../../data/models/product.dart';
import '../../services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _service;

  List<Product> _products = [];
  final Set<int> _favorites = {};
  bool isLoading = false;
  String? errorMessage;

  ProductProvider({ProductService? service})
      : _service = service ?? ProductService() {
    fetchProducts();
  }

  List<Product> get products => List.unmodifiable(_products);

  List<Product> get favoriteProducts =>
      _products.where((p) => _favorites.contains(p.id)).toList();

  int get favoriteCount => _favorites.length;

  double get favoritesTotal =>
      favoriteProducts.fold(0, (sum, p) => sum + p.price);

  bool isFavorite(int id) => _favorites.contains(id);

  void toggleFavorite(int id) {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _products = await _service.fetchProducts();
    } catch (e) {
      errorMessage = 'Failed to load products. Check your connection.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final created = await _service.addProduct(product);
      _products = [..._products, created];
    } catch (e) {
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    try {
      final updated = await _service.updateProduct(product);
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        final newList = [..._products];
        newList[index] = updated;
        _products = newList;
      }
    } catch (e) {
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _service.deleteProduct(id);
      _products = _products.where((p) => p.id != id).toList();
      _favorites.remove(id);
    } catch (e) {
      errorMessage = e.toString();
    }
    notifyListeners();
  }
}
