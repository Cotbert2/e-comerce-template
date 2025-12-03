import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class MainNavigationPage extends StatefulWidget {
  final Widget child;

  const MainNavigationPage({super.key, required this.child});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
              // Using Navigator for simplicity instead of GoRouter context
              switch (index) {
                case 0:
                  Navigator.of(context).pushReplacementNamed('/');
                  break;
                case 1:
                  Navigator.of(context).pushNamed('/cart');
                  break;
              }
            },
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    const Icon(Icons.shopping_cart),
                    if (cartProvider.itemCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            '${cartProvider.itemCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                label: 'Cart',
              ),
            ],
          );
        },
      ),
    );
  }
}