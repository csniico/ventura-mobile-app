import 'package:ventura/features/sales/domain/entities/customer_entity.dart';

class CustomerModel extends Customer {
  CustomerModel({
    required super.id,
    required super.shortId,
    required super.businessId,
    required super.name,
    super.email,
    super.phone,
    super.notes,
    required super.createdAt,
    required super.updatedAt,
    super.deletedAt,
  });

  factory CustomerModel.empty() {
    return CustomerModel(
      id: '',
      shortId: '',
      businessId: '',
      name: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] ?? '',
      shortId: json['shortId'] ?? '',
      businessId: json['businessId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'],
      phone: json['phone'],
      notes: json['notes'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'])
          : null,
    );
  }

  factory CustomerModel.fromEntity(Customer customer) {
    return CustomerModel(
      id: customer.id,
      shortId: customer.shortId,
      businessId: customer.businessId,
      name: customer.name,
      email: customer.email,
      phone: customer.phone,
      notes: customer.notes,
      createdAt: customer.createdAt,
      updatedAt: customer.updatedAt,
      deletedAt: customer.deletedAt,
    );
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'] ?? '',
      shortId: map['shortId'] ?? '',
      businessId: map['businessId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'],
      phone: map['phone'],
      notes: map['notes'],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
      deletedAt: map['deletedAt'] != null
          ? DateTime.parse(map['deletedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shortId': shortId,
      'businessId': businessId,
      'name': name,
      'email': email,
      'phone': phone,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shortId': shortId,
      'businessId': businessId,
      'name': name,
      'email': email,
      'phone': phone,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  Customer toEntity() {
    return Customer(
      id: id,
      shortId: shortId,
      businessId: businessId,
      name: name,
      email: email,
      phone: phone,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }
}
