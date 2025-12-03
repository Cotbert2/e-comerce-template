import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/home_page.dart';
import '../pages/cart_page.dart';
import '../pages/main_navigation_page.dart';

class AppRouter {
  static GoRouter get router => _router;

  static final _router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainNavigationPage(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/cart',
            name: 'cart',
            builder: (context, state) => const CartPage(),
          ),
        ],
      ),
    ],
  );
}