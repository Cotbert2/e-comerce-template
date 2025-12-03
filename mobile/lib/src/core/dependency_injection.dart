import 'package:graphql_flutter/graphql_flutter.dart';

// Data Sources
import '../data/datasources/product_remote_datasource.dart';
import '../data/datasources/auth_datasource.dart';

// Repositories
import '../data/repositories/product_repository_impl.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/product_repository.dart';
import '../domain/repositories/auth_repository.dart';

// Use Cases
import '../domain/usecases/get_products_usecase.dart';
import '../domain/usecases/get_categories_usecase.dart';
import '../domain/usecases/get_products_by_category_usecase.dart';

// Providers
import '../presentation/providers/product_provider.dart';
import '../presentation/providers/cart_provider.dart';

// Network
import '../core/network/graphql_config.dart';

class DependencyInjection {
  static late GraphQLClient _graphqlClient;
  
  // Data Sources
  static late ProductRemoteDataSourceImpl _productRemoteDataSource;
  static late AuthRemoteDataSourceImpl _authRemoteDataSource;
  static late AuthLocalDataSourceImpl _authLocalDataSource;
  
  // Repositories
  static late ProductRepository _productRepository;
  static late AuthRepository _authRepository;
  
  // Use Cases
  static late GetProductsUseCase _getProductsUseCase;
  static late GetCategoriesUseCase _getCategoriesUseCase;
  static late GetProductsByCategoryUseCase _getProductsByCategoryUseCase;
  
  // Providers
  static late ProductProvider _productProvider;
  static late CartProvider _cartProvider;

  static void initialize() {
    // Initialize GraphQL Client
    _graphqlClient = GraphQLConfig.getClient();
    
    // Initialize Data Sources
    _productRemoteDataSource = ProductRemoteDataSourceImpl(client: _graphqlClient);
    _authRemoteDataSource = AuthRemoteDataSourceImpl(client: _graphqlClient);
    _authLocalDataSource = AuthLocalDataSourceImpl();
    
    // Initialize Repositories
    _productRepository = ProductRepositoryImpl(remoteDataSource: _productRemoteDataSource);
    _authRepository = AuthRepositoryImpl(
      remoteDataSource: _authRemoteDataSource,
      localDataSource: _authLocalDataSource,
    );
    
    // Initialize Use Cases
    _getProductsUseCase = GetProductsUseCase(_productRepository);
    _getCategoriesUseCase = GetCategoriesUseCase(_productRepository);
    _getProductsByCategoryUseCase = GetProductsByCategoryUseCase(_productRepository);
    
    // Initialize Providers
    _productProvider = ProductProvider(
      getProductsUseCase: _getProductsUseCase,
      getCategoriesUseCase: _getCategoriesUseCase,
      getProductsByCategoryUseCase: _getProductsByCategoryUseCase,
    );
    _cartProvider = CartProvider();
  }

  // Getters
  static ProductProvider get productProvider => _productProvider;
  static CartProvider get cartProvider => _cartProvider;
  static AuthRepository get authRepository => _authRepository;
}