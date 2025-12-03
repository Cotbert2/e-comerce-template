import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/checkout_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/checkout/login_step.dart';
import '../widgets/checkout/customer_info_step.dart';
import '../widgets/checkout/shipping_address_step.dart';
import '../widgets/checkout/review_order_step.dart';
import '../widgets/checkout/payment_step.dart';
import '../widgets/checkout/confirmation_step.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> _stepTitles = [
    'Login',
    'Customer Info',
    'Shipping',
    'Review Order',
    'Payment',
    'Confirmation',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();

    // Initialize checkout with current auth state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final checkoutProvider = context.read<CheckoutProvider>();
      
      if (authProvider.isAuthenticated && authProvider.currentUser != null) {
        checkoutProvider.goToStep(CheckoutStep.customerInfo);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildStepContent(CheckoutStep step) {
    switch (step) {
      case CheckoutStep.login:
        return const LoginStep();
      case CheckoutStep.customerInfo:
        return const CustomerInfoStep();
      case CheckoutStep.shippingAddress:
        return const ShippingAddressStep();
      case CheckoutStep.reviewOrder:
        return const ReviewOrderStep();
      case CheckoutStep.payment:
        return const PaymentStep();
      case CheckoutStep.confirmation:
        return const ConfirmationStep();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Consumer<CheckoutProvider>(
          builder: (context, checkoutProvider, child) {
            if (checkoutProvider.isOrderCompleted) {
              return _buildStepContent(CheckoutStep.confirmation);
            }

            return Column(
              children: [
                // Stepper Header
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).colorScheme.surface,
                  child: Row(
                    children: List.generate(_stepTitles.length, (index) {
                      final isActive = index == checkoutProvider.currentStepIndex;
                      final isCompleted = index < checkoutProvider.currentStepIndex;
                      
                      return Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                if (index > 0) 
                                  Expanded(
                                    child: Container(
                                      height: 2,
                                      color: isCompleted 
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey[300],
                                    ),
                                  ),
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isActive 
                                      ? Theme.of(context).colorScheme.primary
                                      : isCompleted 
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey[300],
                                  ),
                                  child: Center(
                                    child: isCompleted
                                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                                      : Text(
                                          '${index + 1}',
                                          style: TextStyle(
                                            color: isActive ? Colors.white : Colors.grey[600],
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                  ),
                                ),
                                if (index < _stepTitles.length - 1)
                                  Expanded(
                                    child: Container(
                                      height: 2,
                                      color: isCompleted && index + 1 <= checkoutProvider.currentStepIndex
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey[300],
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _stepTitles[index],
                              style: TextStyle(
                                fontSize: 10,
                                color: isActive 
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey[600],
                                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                
                // Step Content
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _buildStepContent(checkoutProvider.currentStep),
                  ),
                ),
                
                // Navigation Buttons
                if (checkoutProvider.currentStep != CheckoutStep.confirmation)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        if (checkoutProvider.currentStepIndex > 0)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: checkoutProvider.previousStep,
                              child: const Text('Back'),
                            ),
                          ),
                        if (checkoutProvider.currentStepIndex > 0) 
                          const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: _canProceed(checkoutProvider) 
                              ? () => _handleNext(checkoutProvider)
                              : null,
                            child: checkoutProvider.isProcessing
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(_getNextButtonText(checkoutProvider)),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  bool _canProceed(CheckoutProvider checkoutProvider) {
    switch (checkoutProvider.currentStep) {
      case CheckoutStep.login:
        return checkoutProvider.canProceedFromLogin;
      case CheckoutStep.customerInfo:
        return checkoutProvider.canProceedFromCustomerInfo;
      case CheckoutStep.shippingAddress:
        return checkoutProvider.canProceedFromShipping;
      case CheckoutStep.reviewOrder:
        return true;
      case CheckoutStep.payment:
        return checkoutProvider.canProceedFromPayment;
      case CheckoutStep.confirmation:
        return false;
    }
  }

  String _getNextButtonText(CheckoutProvider checkoutProvider) {
    switch (checkoutProvider.currentStep) {
      case CheckoutStep.payment:
        return 'Place Order';
      case CheckoutStep.confirmation:
        return 'Done';
      default:
        return 'Next';
    }
  }

  void _handleNext(CheckoutProvider checkoutProvider) async {
    if (checkoutProvider.currentStep == CheckoutStep.payment) {
      // Process the order
      final cartProvider = context.read<CartProvider>();
      await checkoutProvider.processOrder(cartProvider.items);
      if (checkoutProvider.isOrderCompleted) {
        cartProvider.clearCart();
      }
    } else {
      checkoutProvider.nextStep();
    }
  }
}