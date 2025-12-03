import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductsByCategoryUseCase {
  final ProductRepository repository;

  GetProductsByCategoryUseCase(this.repository);

  Future<List<Product>> call(String categoryId) async {
    return await repository.getProductsByCategory(categoryId);
  }
}