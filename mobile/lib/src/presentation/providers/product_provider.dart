import 'package:flutter/foundation.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/category.dart' as entity;
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_products_by_category_usecase.dart';

enum ProductLoadingState { initial, loading, loaded, error }

class ProductProvider extends ChangeNotifier {
  final GetProductsUseCase getProductsUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductsByCategoryUseCase getProductsByCategoryUseCase;

  ProductProvider({
    required this.getProductsUseCase,
    required this.getCategoriesUseCase,
    required this.getProductsByCategoryUseCase,
  });

  // State
  List<Product> _products = [];
  List<entity.Category> _categories = [];
  ProductLoadingState _loadingState = ProductLoadingState.initial;
  String? _errorMessage;
  String? _selectedCategoryId;
  int _currentPage = 1;
  bool _hasMoreProducts = true;
  bool _isLoadingMore = false;

  // Getters
  List<Product> get products => _products;
  List<entity.Category> get categories => _categories;
  ProductLoadingState get loadingState => _loadingState;
  String? get errorMessage => _errorMessage;
  String? get selectedCategoryId => _selectedCategoryId;
  bool get isLoading => _loadingState == ProductLoadingState.loading || _isLoadingMore;
  bool get hasMoreProducts => _hasMoreProducts;
  int get currentPage => _currentPage;

  Future<void> loadProducts() async {
    _loadingState = ProductLoadingState.loading;
    _errorMessage = null;
    _currentPage = 1;
    _hasMoreProducts = true;
    notifyListeners();

    try {
      _products = await getProductsUseCase();
      _loadingState = ProductLoadingState.loaded;
      // Simulate pagination - if less than expected, no more products
      _hasMoreProducts = _products.length >= 10;
    } catch (e) {
      _errorMessage = e.toString();
      _loadingState = ProductLoadingState.error;
    }

    notifyListeners();
  }

  Future<void> loadMoreProducts() async {
    if (_isLoadingMore || !_hasMoreProducts) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      // Simulate loading more products by duplicating current ones
      // In a real app, you would call an API with page parameters
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      
      final moreProducts = await getProductsUseCase();
      
      // Simulate pagination logic
      if (moreProducts.isNotEmpty && _currentPage < 3) { // Max 3 pages for demo
        _products.addAll(moreProducts);
        _currentPage++;
      } else {
        _hasMoreProducts = false;
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoadingMore = false;
    notifyListeners();
  }

  Future<void> loadCategories() async {
    try {
      _categories = await getCategoriesUseCase();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadProductsByCategory(String categoryId) async {
    print('DEBUG: Loading products for category: $categoryId');
    _loadingState = ProductLoadingState.loading;
    _errorMessage = null;
    _selectedCategoryId = categoryId;
    notifyListeners();

    try {
      _products = await getProductsByCategoryUseCase(categoryId);
      print('DEBUG: Loaded ${_products.length} products for category $categoryId');
      _loadingState = ProductLoadingState.loaded;
    } catch (e) {
      print('DEBUG: Error loading products by category: $e');
      _errorMessage = e.toString();
      _loadingState = ProductLoadingState.error;
    }

    notifyListeners();
  }

  void clearSelection() {
    _selectedCategoryId = null;
    _currentPage = 1;
    _hasMoreProducts = true;
    notifyListeners();
  }
}