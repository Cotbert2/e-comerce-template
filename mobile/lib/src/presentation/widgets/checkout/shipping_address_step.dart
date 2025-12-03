import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/entities/shipping_address.dart';
import '../../providers/checkout_provider.dart';

class ShippingAddressStep extends StatefulWidget {
  const ShippingAddressStep({super.key});

  @override
  State<ShippingAddressStep> createState() => _ShippingAddressStepState();
}

class _ShippingAddressStepState extends State<ShippingAddressStep> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load existing shipping address if available
    final checkoutProvider = context.read<CheckoutProvider>();
    if (checkoutProvider.shippingAddress != null) {
      _addressController.text = checkoutProvider.shippingAddress!.address;
      _zipCodeController.text = checkoutProvider.shippingAddress!.zipCode;
      _cityController.text = checkoutProvider.shippingAddress!.city;
      _phoneController.text = checkoutProvider.shippingAddress!.contactPhone;
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _zipCodeController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveShippingAddress() {
    if (_formKey.currentState!.validate()) {
      final checkoutProvider = context.read<CheckoutProvider>();
      
      final shippingAddress = ShippingAddress(
        address: _addressController.text.trim(),
        zipCode: _zipCodeController.text.trim(),
        city: _cityController.text.trim(),
        contactPhone: _phoneController.text.trim(),
      );
      
      checkoutProvider.setShippingAddress(shippingAddress);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Shipping address saved'),
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
            'Shipping Address',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Where should we deliver your order?',
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
                    controller: _addressController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Street Address',
                      prefixIcon: Icon(Icons.location_on),
                      border: OutlineInputBorder(),
                      hintText: 'Street, building number, apartment',
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _zipCodeController,
                          decoration: const InputDecoration(
                            labelText: 'Zip Code',
                            prefixIcon: Icon(Icons.local_post_office),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter zip code';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _cityController,
                          decoration: const InputDecoration(
                            labelText: 'City',
                            prefixIcon: Icon(Icons.location_city),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter city';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Contact Phone',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter contact phone';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveShippingAddress,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Save Address'),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  Consumer<CheckoutProvider>(
                    builder: (context, checkoutProvider, child) {
                      if (checkoutProvider.shippingAddress != null) {
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
                                  'Shipping address saved successfully',
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