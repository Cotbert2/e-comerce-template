import 'package:equatable/equatable.dart';

enum PaymentMethodType { creditCard, debitCard, giftCard, paypal }

class PaymentMethod extends Equatable {
  final String? id;
  final PaymentMethodType type;
  final String? cardNumber;
  final String? cardName;
  final String? cardExpiration;
  final String? cardCVC;
  final String? giftCardNumber;
  final double? giftCardAmount;
  final String userId;

  const PaymentMethod({
    this.id,
    required this.type,
    this.cardNumber,
    this.cardName,
    this.cardExpiration,
    this.cardCVC,
    this.giftCardNumber,
    this.giftCardAmount,
    required this.userId,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        cardNumber,
        cardName,
        cardExpiration,
        cardCVC,
        giftCardNumber,
        giftCardAmount,
        userId,
      ];

  String get displayName {
    switch (type) {
      case PaymentMethodType.creditCard:
      case PaymentMethodType.debitCard:
        return '**** ${cardNumber?.substring(cardNumber!.length - 4)}';
      case PaymentMethodType.giftCard:
        return 'Gift Card \$${giftCardAmount?.toStringAsFixed(2)}';
      case PaymentMethodType.paypal:
        return 'PayPal';
    }
  }
}