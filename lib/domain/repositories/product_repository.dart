import 'package:state_mobile_aula01/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<Product> toggleFavorite(int productId);
}
