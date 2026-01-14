import 'package:ventura/features/sales/domain/entities/service_entity.dart';

class ServiceModel extends Service {
  ServiceModel({
    required super.id,
    required super.shortId,
    required super.name,
    super.primaryImage,
    super.supportingImages,
    required super.businessId,
    super.description,
    super.notes,
    required super.price,
    super.businessHours,
    required super.createdAt,
    required super.updatedAt,
    super.deletedAt,
  });

  factory ServiceModel.empty() {
    return ServiceModel(
      id: '',
      shortId: '',
      name: '',
      businessId: '',
      price: 0.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? '',
      shortId: json['shortId'] ?? '',
      name: json['name'] ?? '',
      primaryImage: json['primaryImage'],
      supportingImages: json['supportingImages'] != null
          ? List<String>.from(json['supportingImages'])
          : null,
      businessId: json['businessId'] ?? '',
      description: json['description'],
      notes: json['notes'],
      price: (json['price'] is String)
          ? double.parse(json['price'])
          : (json['price'] ?? 0.0).toDouble(),
      businessHours: json['businessHours'] != null
          ? Map<String, dynamic>.from(json['businessHours'])
          : null,
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

  factory ServiceModel.fromEntity(Service service) {
    return ServiceModel(
      id: service.id,
      shortId: service.shortId,
      name: service.name,
      primaryImage: service.primaryImage,
      supportingImages: service.supportingImages,
      businessId: service.businessId,
      description: service.description,
      notes: service.notes,
      price: service.price,
      businessHours: service.businessHours,
      createdAt: service.createdAt,
      updatedAt: service.updatedAt,
      deletedAt: service.deletedAt,
    );
  }

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: map['id'] ?? '',
      shortId: map['shortId'] ?? '',
      name: map['name'] ?? '',
      primaryImage: map['primaryImage'],
      supportingImages: map['supportingImages'] != null
          ? List<String>.from(map['supportingImages'])
          : null,
      businessId: map['businessId'] ?? '',
      description: map['description'],
      notes: map['notes'],
      price: (map['price'] is String)
          ? double.parse(map['price'])
          : (map['price'] ?? 0.0).toDouble(),
      businessHours: map['businessHours'] != null
          ? Map<String, dynamic>.from(map['businessHours'])
          : null,
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
      'name': name,
      'primaryImage': primaryImage,
      'supportingImages': supportingImages,
      'businessId': businessId,
      'description': description,
      'notes': notes,
      'price': price,
      'businessHours': businessHours,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shortId': shortId,
      'name': name,
      'primaryImage': primaryImage,
      'supportingImages': supportingImages,
      'businessId': businessId,
      'description': description,
      'notes': notes,
      'price': price,
      'businessHours': businessHours,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  Service toEntity() {
    return Service(
      id: id,
      shortId: shortId,
      name: name,
      primaryImage: primaryImage,
      supportingImages: supportingImages,
      businessId: businessId,
      description: description,
      notes: notes,
      price: price,
      businessHours: businessHours,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }
}
