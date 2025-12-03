import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemWidget({
    super.key,
    required this.cartItem,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: cartItem.product.image,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image, size: 20),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported, size: 20),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        cartItem.product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      children: [
                        if (cartItem.product.discount > 0) ...[
                          Text(
                            '\$${cartItem.product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          '\$${cartItem.product.finalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Quantity Controls
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: IconButton(
                            onPressed: cartItem.quantity > 1
                                ? () => onQuantityChanged(cartItem.quantity - 1)
                                : null,
                            icon: const Icon(Icons.remove, size: 16),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              foregroundColor: Colors.black,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '${cartItem.quantity}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: IconButton(
                            onPressed: () => onQuantityChanged(cartItem.quantity + 1),
                            icon: const Icon(Icons.add, size: 16),
                            style: IconButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '\$${cartItem.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Remove Button
              SizedBox(
                width: 32,
                height: 32,
                child: IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline, size: 18),
                  color: Colors.red,
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}