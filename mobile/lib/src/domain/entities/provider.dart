import 'package:equatable/equatable.dart';

class Provider extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String description;
  final String country;

  const Provider({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.description,
    required this.country,
  });

  @override
  List<Object?> get props => [id, name, email, phone, description, country];
}