import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        if (productProvider.categories.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          height: 60,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: productProvider.categories.length + 1, // +1 for "All" option
            itemBuilder: (context, index) {
              if (index == 0) {
                // "All" option
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: const Text('All'),
                    selected: productProvider.selectedCategoryId == null,
                    onSelected: (selected) {
                      if (selected) {
                        productProvider.clearSelection();
                        productProvider.loadProducts();
                      }
                    },
                  ),
                );
              }

              final category = productProvider.categories[index - 1];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(category.name),
                  selected: productProvider.selectedCategoryId == category.id,
                  onSelected: (selected) {
                    if (selected) {
                      productProvider.loadProductsByCategory(category.id);
                    }
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}