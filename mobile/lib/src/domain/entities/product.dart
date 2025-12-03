import 'package:equatable/equatable.dart';
import 'category.dart';
import 'provider.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final double price;
  final String description;
  final double stock;
  final Category category;
  final Provider provider;
  final double rating;
  final double discount;
  final String image;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.stock,
    required this.category,
    required this.provider,
    required this.rating,
    required this.discount,
    required this.image,
  });

  double get finalPrice => price - (price * discount / 100);

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        description,
        stock,
        category,
        provider,
        rating,
        discount,
        image,
      ];
}