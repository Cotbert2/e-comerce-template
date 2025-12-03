import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/product.dart';
import '../providers/cart_provider.dart';
import 'product_card.dart';

class ProductGrid extends StatefulWidget {
  final List<Product> products;
  final ScrollController scrollController;

  const ProductGrid({
    super.key,
    required this.products,
    required this.scrollController,
  });

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: widget.scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: widget.products.length,
      itemBuilder: (context, index) {
        final product = widget.products[index];
        return ProductCard(
          product: product,
          onAddToCart: () {
            context.read<CartProvider>().addToCart(product);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${product.name} added to cart'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        );
      },
    );
  }
}