import 'package:equatable/equatable.dart';

class ShippingAddress extends Equatable {
  final String address;
  final String zipCode;
  final String city;
  final String contactPhone;

  const ShippingAddress({
    required this.address,
    required this.zipCode,
    required this.city,
    required this.contactPhone,
  });

  @override
  List<Object?> get props => [address, zipCode, city, contactPhone];

  ShippingAddress copyWith({
    String? address,
    String? zipCode,
    String? city,
    String? contactPhone,
  }) {
    return ShippingAddress(
      address: address ?? this.address,
      zipCode: zipCode ?? this.zipCode,
      city: city ?? this.city,
      contactPhone: contactPhone ?? this.contactPhone,
    );
  }
}