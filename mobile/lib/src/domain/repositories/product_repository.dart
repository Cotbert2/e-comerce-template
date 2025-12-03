import '../entities/product.dart';
import '../entities/category.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<List<Product>> getProductsByCategory(String categoryId);
  Future<List<Category>> getCategories();
}