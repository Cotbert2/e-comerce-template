import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/checkout_provider.dart';
import '../../pages/login_page.dart';

class LoginStep extends StatelessWidget {
  const LoginStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  authProvider.isAuthenticated ? Icons.check_circle : Icons.account_circle,
                  size: 80,
                  color: authProvider.isAuthenticated 
                    ? Colors.green 
                    : Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),
                
                if (authProvider.isAuthenticated && authProvider.currentUser != null) ...[
                  Text(
                    'Welcome back!',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    authProvider.currentUser!.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    authProvider.currentUser!.email,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'You are logged in and ready to proceed with your order.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ] else ...[
                  Text(
                    'Please log in to continue',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'You need to log in to your account to proceed with the checkout process.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        ).then((_) {
                          // After returning from login, update checkout provider
                          if (authProvider.isAuthenticated) {
                            context.read<CheckoutProvider>().goToStep(CheckoutStep.customerInfo);
                          }
                        });
                      },
                      icon: const Icon(Icons.login),
                      label: const Text('Log In'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}