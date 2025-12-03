import '../../domain/entities/provider.dart';

class ProviderModel extends Provider {
  const ProviderModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.description,
    required super.country,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      description: json['description'] ?? '',
      country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'description': description,
      'country': country,
    };
  }
}