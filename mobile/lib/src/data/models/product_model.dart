import '../../domain/entities/product.dart';
import 'category_model.dart';
import 'provider_model.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.price,
    required super.description,
    required super.stock,
    required super.category,
    required super.provider,
    required super.rating,
    required super.discount,
    required super.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] ?? '',
      stock: (json['stock'] as num?)?.toDouble() ?? 0.0,
      category: CategoryModel.fromJson(json['category'] ?? {}),
      provider: ProviderModel.fromJson(json['provider'] ?? {}),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'stock': stock,
      'category': (category as CategoryModel).toJson(),
      'provider': (provider as ProviderModel).toJson(),
      'rating': rating,
      'discount': discount,
      'image': image,
    };
  }
}