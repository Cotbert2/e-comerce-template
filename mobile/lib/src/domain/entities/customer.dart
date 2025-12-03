import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  final String? id;
  final String name;
  final String phone;
  final String identification;
  final String userId;

  const Customer({
    this.id,
    required this.name,
    required this.phone,
    required this.identification,
    required this.userId,
  });

  @override
  List<Object?> get props => [id, name, phone, identification, userId];

  Customer copyWith({
    String? id,
    String? name,
    String? phone,
    String? identification,
    String? userId,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      identification: identification ?? this.identification,
      userId: userId ?? this.userId,
    );
  }
}