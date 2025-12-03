import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/product.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
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
  void initState() {
    super.initState();
    // Setup infinite scroll listener
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    // Check if we're near the bottom of the scroll
    if (widget.scrollController.position.pixels >=
        widget.scrollController.position.maxScrollExtent - 200) {
      // Load more products when near bottom
      final productProvider = context.read<ProductProvider>();
      if (!productProvider.isLoading && productProvider.hasMoreProducts) {
        productProvider.loadMoreProducts();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return GridView.builder(
          controller: widget.scrollController,
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          // Add 1 if loading more products to show loading indicator
          itemCount: widget.products.length + (productProvider.isLoading && productProvider.currentPage > 1 ? 1 : 0),
          itemBuilder: (context, index) {
            // Show loading indicator at the bottom when loading more products
            if (index == widget.products.length && productProvider.isLoading && productProvider.currentPage > 1) {
              return const Card(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }

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
      },
    );
  }
}