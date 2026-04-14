import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../data/models/product.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  final Set<int> _favorites = {};
  bool isLoading = false;
  String? errorMessage;

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

  ProductProvider() {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://fakestoreapi.com/products'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        _products = jsonList.map((json) => Product.fromJson(json)).toList();
      } else {
        errorMessage = 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage = 'Failed to load products. Check your connection.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
