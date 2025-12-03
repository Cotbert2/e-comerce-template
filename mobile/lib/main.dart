import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'src/core/dependency_injection.dart';
import 'src/core/network/graphql_config.dart';
import 'src/presentation/pages/home_page.dart';
import 'src/presentation/pages/cart_page.dart';
import 'src/presentation/pages/splash_page.dart';
import 'src/presentation/pages/login_page.dart';
import 'src/presentation/pages/checkout_page.dart';
import 'src/presentation/providers/auth_provider.dart';
import 'src/presentation/providers/checkout_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for GraphQL cache
  await initHiveForFlutter();
  
  // Initialize Dependencies
  DependencyInjection.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GraphQLConfig.getClientNotifier(),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: DependencyInjection.productProvider,
          ),
          ChangeNotifierProvider.value(
            value: DependencyInjection.cartProvider,
          ),
          ChangeNotifierProvider(
            create: (_) => AuthProvider(authRepository: DependencyInjection.authRepository),
          ),
          ChangeNotifierProvider(
            create: (_) => CheckoutProvider(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'E-Commerce App',
          theme: ThemeData(
            colorSchemeSeed: Colors.blue,
            useMaterial3: true,
          ),
          initialRoute: '/splash',
          routes: {
            '/splash': (context) => const SplashPage(),
            '/': (context) => const HomePage(),
            '/cart': (context) => const CartPage(),
            '/login': (context) => const LoginPage(),
            '/checkout': (context) => const CheckoutPage(),
          },
        ),
      ),
    );
  }
}
