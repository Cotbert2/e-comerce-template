import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<List<ProductModel>> getProductsByCategory(String categoryId);
  Future<List<CategoryModel>> getCategories();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final GraphQLClient client;

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getProducts() async {
    const String query = '''
      query GetProducts {
        products {
          id
          name
          price
          description
          stock
          rating
          discount
          image
          category {
            id
            name
            description
          }
          provider {
            id
            name
            email
            phone
            description
            country
          }
        }
      }
    ''';

    final QueryOptions options = QueryOptions(document: gql(query));
    final QueryResult result = await client.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final List<dynamic> productsData = result.data?['products'] ?? [];
    return productsData.map((json) => ProductModel.fromJson(json)).toList();
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    print('DEBUG: GraphQL query for category: $categoryId');
    const String query = '''
      query GetProductsByCategory(\$category: String!) {
        productsByCategory(category: \$category) {
          id
          name
          price
          description
          stock
          rating
          discount
          image
          category {
            id
            name
            description
          }
          provider {
            id
            name
            email
            phone
            description
            country
          }
        }
      }
    ''';

    final QueryOptions options = QueryOptions(
      document: gql(query),
      variables: {'category': categoryId},
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      print('DEBUG: GraphQL exception: ${result.exception.toString()}');
      throw Exception(result.exception.toString());
    }

    final List<dynamic> productsData = result.data?['productsByCategory'] ?? [];
    print('DEBUG: GraphQL returned ${productsData.length} products for category $categoryId');
    return productsData.map((json) => ProductModel.fromJson(json)).toList();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    const String query = '''
      query GetCategories {
        categories {
          id
          name
          description
        }
      }
    ''';

    final QueryOptions options = QueryOptions(document: gql(query));
    final QueryResult result = await client.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final List<dynamic> categoriesData = result.data?['categories'] ?? [];
    return categoriesData.map((json) => CategoryModel.fromJson(json)).toList();
  }
}