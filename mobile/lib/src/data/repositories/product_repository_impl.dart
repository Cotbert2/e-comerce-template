import '../../domain/entities/product.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Product>> getProducts() async {
    try {
      return await remoteDataSource.getProducts();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  @override
  Future<List<Product>> getProductsByCategory(String categoryId) async {
    try {
      return await remoteDataSource.getProductsByCategory(categoryId);
    } catch (e) {
      throw Exception('Failed to fetch products by category: $e');
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    try {
      return await remoteDataSource.getCategories();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }
}