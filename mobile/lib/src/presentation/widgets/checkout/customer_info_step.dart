import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/entities/customer.dart';
import '../../providers/checkout_provider.dart';
import '../../providers/auth_provider.dart';

class CustomerInfoStep extends StatefulWidget {
  const CustomerInfoStep({super.key});

  @override
  State<CustomerInfoStep> createState() => _CustomerInfoStepState();
}

class _CustomerInfoStepState extends State<CustomerInfoStep> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _identificationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill with user data if available
    final authProvider = context.read<AuthProvider>();
    if (authProvider.currentUser != null) {
      _nameController.text = authProvider.currentUser!.name;
      _phoneController.text = authProvider.currentUser!.phone;
    }

    // Load existing customer data if available
    final checkoutProvider = context.read<CheckoutProvider>();
    if (checkoutProvider.customer != null) {
      _nameController.text = checkoutProvider.customer!.name;
      _phoneController.text = checkoutProvider.customer!.phone;
      _identificationController.text = checkoutProvider.customer!.identification;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _identificationController.dispose();
    super.dispose();
  }

  void _saveCustomerInfo() {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      final checkoutProvider = context.read<CheckoutProvider>();
      
      final customer = Customer(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        identification: _identificationController.text.trim(),
        userId: authProvider.currentUser!.id,
      );
      
      checkoutProvider.setCustomer(customer);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Customer information saved'),
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
            'Customer Information',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please provide your billing information for this order.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          
          Expanded(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _identificationController,
                    decoration: const InputDecoration(
                      labelText: 'Identification (ID/Passport)',
                      prefixIcon: Icon(Icons.badge),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your identification';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveCustomerInfo,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Save Information'),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  Consumer<CheckoutProvider>(
                    builder: (context, checkoutProvider, child) {
                      if (checkoutProvider.customer != null) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green.shade600),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'Customer information saved successfully',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}