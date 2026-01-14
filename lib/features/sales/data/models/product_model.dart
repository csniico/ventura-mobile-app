import 'package:ventura/features/sales/domain/entities/product_entity.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.shortId,
    required super.name,
    super.primaryImage,
    super.supportingImages,
    required super.availableQuantity,
    required super.businessId,
    super.description,
    super.notes,
    required super.price,
    required super.createdAt,
    required super.updatedAt,
    super.deletedAt,
  });

  factory ProductModel.empty() {
    return ProductModel(
      id: '',
      shortId: '',
      name: '',
      availableQuantity: 0,
      businessId: '',
      price: 0.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      shortId: json['shortId'] ?? '',
      name: json['name'] ?? '',
      primaryImage: json['primaryImage'],
      supportingImages: json['supportingImages'] != null
          ? List<String>.from(json['supportingImages'])
          : null,
      availableQuantity: json['availableQuantity'] ?? 0,
      businessId: json['businessId'] ?? '',
      description: json['description'],
      notes: json['notes'],
      price: (json['price'] is String)
          ? double.parse(json['price'])
          : (json['price'] ?? 0.0).toDouble(),
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

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      shortId: product.shortId,
      name: product.name,
      primaryImage: product.primaryImage,
      supportingImages: product.supportingImages,
      availableQuantity: product.availableQuantity,
      businessId: product.businessId,
      description: product.description,
      notes: product.notes,
      price: product.price,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
      deletedAt: product.deletedAt,
    );
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? '',
      shortId: map['shortId'] ?? '',
      name: map['name'] ?? '',
      primaryImage: map['primaryImage'],
      supportingImages: map['supportingImages'] != null
          ? List<String>.from(map['supportingImages'])
          : null,
      availableQuantity: map['availableQuantity'] ?? 0,
      businessId: map['businessId'] ?? '',
      description: map['description'],
      notes: map['notes'],
      price: (map['price'] is String)
          ? double.parse(map['price'])
          : (map['price'] ?? 0.0).toDouble(),
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
      'availableQuantity': availableQuantity,
      'businessId': businessId,
      'description': description,
      'notes': notes,
      'price': price,
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
      'availableQuantity': availableQuantity,
      'businessId': businessId,
      'description': description,
      'notes': notes,
      'price': price,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  Product toEntity() {
    return Product(
      id: id,
      shortId: shortId,
      name: name,
      primaryImage: primaryImage,
      supportingImages: supportingImages,
      availableQuantity: availableQuantity,
      businessId: businessId,
      description: description,
      notes: notes,
      price: price,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }
}
