import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/models/product.dart';

class ProductService {
  final http.Client _client;
  static const String _baseUrl = 'https://fakestoreapi.com';

  ProductService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Product>> fetchProducts() async {
    final response = await _client.get(Uri.parse('$_baseUrl/products'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Product.fromJson(json)).toList();
  }

  Future<Product> addProduct(Product product) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/products'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add product: ${response.statusCode}');
    }
    return Product.fromJson(jsonDecode(response.body));
  }

  Future<Product> updateProduct(Product product) async {
    final response = await _client.put(
      Uri.parse('$_baseUrl/products/${product.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update product: ${response.statusCode}');
    }
    return Product.fromJson(jsonDecode(response.body));
  }

  Future<void> deleteProduct(int id) async {
    final response = await _client.delete(
      Uri.parse('$_baseUrl/products/$id'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete product: ${response.statusCode}');
    }
  }
}
