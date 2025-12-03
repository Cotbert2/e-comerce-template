import 'package:flutter/foundation.dart';
import '../../domain/entities/customer.dart';
import '../../domain/entities/shipping_address.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/entities/cart_item.dart';

enum CheckoutStep { login, customerInfo, shippingAddress, reviewOrder, payment, confirmation }

class CheckoutProvider extends ChangeNotifier {
  // State
  CheckoutStep _currentStep = CheckoutStep.login;
  Customer? _customer;
  ShippingAddress? _shippingAddress;
  PaymentMethod? _selectedPaymentMethod;
  List<PaymentMethod> _paymentMethods = [];
  bool _isProcessing = false;
  String? _errorMessage;
  bool _isOrderCompleted = false;

  // Getters
  CheckoutStep get currentStep => _currentStep;
  Customer? get customer => _customer;
  ShippingAddress? get shippingAddress => _shippingAddress;
  PaymentMethod? get selectedPaymentMethod => _selectedPaymentMethod;
  List<PaymentMethod> get paymentMethods => _paymentMethods;
  bool get isProcessing => _isProcessing;
  String? get errorMessage => _errorMessage;
  bool get isOrderCompleted => _isOrderCompleted;
  
  int get currentStepIndex => _currentStep.index;

  // Validation methods
  bool get canProceedFromLogin => _customer != null;
  bool get canProceedFromCustomerInfo => _customer != null;
  bool get canProceedFromShipping => _shippingAddress != null;
  bool get canProceedFromPayment => _selectedPaymentMethod != null;

  void nextStep() {
    if (_currentStep.index < CheckoutStep.values.length - 1) {
      _currentStep = CheckoutStep.values[_currentStep.index + 1];
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep.index > 0) {
      _currentStep = CheckoutStep.values[_currentStep.index - 1];
      notifyListeners();
    }
  }

  void goToStep(CheckoutStep step) {
    _currentStep = step;
    notifyListeners();
  }

  void setCustomer(Customer customer) {
    _customer = customer;
    notifyListeners();
  }

  void setShippingAddress(ShippingAddress address) {
    _shippingAddress = address;
    notifyListeners();
  }

  void setSelectedPaymentMethod(PaymentMethod paymentMethod) {
    _selectedPaymentMethod = paymentMethod;
    notifyListeners();
  }

  void addPaymentMethod(PaymentMethod paymentMethod) {
    _paymentMethods.add(paymentMethod);
    notifyListeners();
  }

  Future<void> processOrder(List<CartItem> cartItems) async {
    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate order processing
      await Future.delayed(const Duration(seconds: 2));
      
      // TODO: Implement actual order processing with GraphQL mutation
      
      _isOrderCompleted = true;
      _currentStep = CheckoutStep.confirmation;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  void reset() {
    _currentStep = CheckoutStep.login;
    _customer = null;
    _shippingAddress = null;
    _selectedPaymentMethod = null;
    _paymentMethods.clear();
    _isProcessing = false;
    _errorMessage = null;
    _isOrderCompleted = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}