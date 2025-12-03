import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/entities/payment_method.dart';
import '../../providers/checkout_provider.dart';

class PaymentStep extends StatefulWidget {
  const PaymentStep({super.key});

  @override
  State<PaymentStep> createState() => _PaymentStepState();
}

class _PaymentStepState extends State<PaymentStep> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _cardFormKey = GlobalKey<FormState>();
  final _giftCardFormKey = GlobalKey<FormState>();
  
  // Card form controllers
  final _cardNameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expirationController = TextEditingController();
  final _cvvController = TextEditingController();
  
  // Gift card controller
  final _giftCardController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cardNameController.dispose();
    _cardNumberController.dispose();
    _expirationController.dispose();
    _cvvController.dispose();
    _giftCardController.dispose();
    super.dispose();
  }

  void _addCreditCard() {
    if (_cardFormKey.currentState!.validate()) {
      final checkoutProvider = context.read<CheckoutProvider>();
      
      final paymentMethod = PaymentMethod(
        type: PaymentMethodType.creditCard,
        cardName: _cardNameController.text.trim(),
        cardNumber: _cardNumberController.text.trim(),
        cardExpiration: _expirationController.text.trim(),
        cardCVC: _cvvController.text.trim(),
        userId: 'current_user', // Should be actual user ID
      );
      
      checkoutProvider.addPaymentMethod(paymentMethod);
      checkoutProvider.setSelectedPaymentMethod(paymentMethod);
      
      // Clear form
      _cardFormKey.currentState!.reset();
      _cardNameController.clear();
      _cardNumberController.clear();
      _expirationController.clear();
      _cvvController.clear();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Credit card added successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _addGiftCard() {
    if (_giftCardFormKey.currentState!.validate()) {
      final checkoutProvider = context.read<CheckoutProvider>();
      
      // Simulate gift card validation
      final amount = 50.0 + (100.0 * (_giftCardController.text.length % 5));
      
      final paymentMethod = PaymentMethod(
        type: PaymentMethodType.giftCard,
        giftCardNumber: _giftCardController.text.trim(),
        giftCardAmount: amount,
        userId: 'current_user', // Should be actual user ID
      );
      
      checkoutProvider.addPaymentMethod(paymentMethod);
      checkoutProvider.setSelectedPaymentMethod(paymentMethod);
      
      // Clear form
      _giftCardFormKey.currentState!.reset();
      _giftCardController.clear();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gift card added successfully (\$${amount.toStringAsFixed(2)})'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose how you would like to pay for your order.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Existing Payment Methods
                  Consumer<CheckoutProvider>(
                    builder: (context, checkoutProvider, child) {
                      if (checkoutProvider.paymentMethods.isNotEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Saved Payment Methods',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            ...checkoutProvider.paymentMethods.map(
                              (method) => Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: RadioListTile<PaymentMethod>(
                                  value: method,
                                  groupValue: checkoutProvider.selectedPaymentMethod,
                                  onChanged: (value) {
                                    checkoutProvider.setSelectedPaymentMethod(value!);
                                  },
                                  title: Text(method.displayName),
                                  subtitle: Text(_getPaymentMethodSubtitle(method)),
                                  secondary: Icon(_getPaymentMethodIcon(method)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Divider(),
                            const SizedBox(height: 24),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  
                  // Add New Payment Method
                  const Text(
                    'Add New Payment Method',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        TabBar(
                          tabs: const [
                            Tab(icon: Icon(Icons.credit_card), text: 'Credit Card'),
                            Tab(icon: Icon(Icons.card_giftcard), text: 'Gift Card'),
                            Tab(icon: Icon(Icons.account_balance_wallet), text: 'PayPal'),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        SizedBox(
                          height: 400, // Fixed height for TabBarView content
                          child: TabBarView(
                            children: [
                              // Credit Card Form
                              _buildCreditCardForm(),
                              
                              // Gift Card Form
                              _buildGiftCardForm(),
                              
                              // PayPal
                              _buildPayPalOption(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCreditCardForm() {
    return SingleChildScrollView(
      child: Form(
        key: _cardFormKey,
        child: Column(
          children: [
            TextFormField(
              controller: _cardNameController,
              decoration: const InputDecoration(
                labelText: 'Cardholder Name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty == true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Card Number',
                prefixIcon: Icon(Icons.credit_card),
                border: OutlineInputBorder(),
                hintText: '1234 5678 9012 3456',
              ),
              validator: (value) {
                if (value?.isEmpty == true) return 'Required';
                if (value!.replaceAll(' ', '').length < 16) return 'Invalid card number';
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _expirationController,
                    decoration: const InputDecoration(
                      labelText: 'MM/YY',
                      prefixIcon: Icon(Icons.calendar_month),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.isEmpty == true ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _cvvController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                      prefixIcon: Icon(Icons.security),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.isEmpty == true ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addCreditCard,
                child: const Text('Add Credit Card'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildGiftCardForm() {
    return SingleChildScrollView(
      child: Form(
        key: _giftCardFormKey,
        child: Column(
          children: [
            TextFormField(
              controller: _giftCardController,
              decoration: const InputDecoration(
                labelText: 'Gift Card Number',
                prefixIcon: Icon(Icons.card_giftcard),
                border: OutlineInputBorder(),
                hintText: 'Enter your gift card code',
              ),
              validator: (value) => value?.isEmpty == true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.blue.shade600),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Gift cards are not accumulative. Make sure your gift card amount covers the total order amount.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addGiftCard,
                child: const Text('Validate Gift Card'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPayPalOption() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.account_balance_wallet,
          size: 80,
          color: Colors.blue[600],
        ),
        const SizedBox(height: 24),
        const Text(
          'PayPal',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text(
          'Pay securely with your PayPal account',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 32),
        
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              final checkoutProvider = context.read<CheckoutProvider>();
              final paymentMethod = PaymentMethod(
                type: PaymentMethodType.paypal,
                userId: 'current_user',
              );
              checkoutProvider.setSelectedPaymentMethod(paymentMethod);
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('PayPal selected as payment method'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            icon: const Icon(Icons.account_balance_wallet),
            label: const Text('Select PayPal'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
  
  String _getPaymentMethodSubtitle(PaymentMethod method) {
    switch (method.type) {
      case PaymentMethodType.creditCard:
        return 'Expires ${method.cardExpiration}';
      case PaymentMethodType.giftCard:
        return 'Card Number: ${method.giftCardNumber}';
      case PaymentMethodType.paypal:
        return 'PayPal Account';
      case PaymentMethodType.debitCard:
        return 'Debit Card';
    }
  }
  
  IconData _getPaymentMethodIcon(PaymentMethod method) {
    switch (method.type) {
      case PaymentMethodType.creditCard:
      case PaymentMethodType.debitCard:
        return Icons.credit_card;
      case PaymentMethodType.giftCard:
        return Icons.card_giftcard;
      case PaymentMethodType.paypal:
        return Icons.account_balance_wallet;
    }
  }
}