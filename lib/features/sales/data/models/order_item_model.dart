import 'package:ventura/features/sales/domain/entities/item_type.dart';
import 'package:ventura/features/sales/domain/entities/order_item_entity.dart';
import 'package:ventura/features/sales/data/models/product_model.dart';
import 'package:ventura/features/sales/data/models/service_model.dart';

class OrderItemModel extends OrderItem {
  OrderItemModel({
    required super.id,
    required super.itemType,
    required super.name,
    required super.price,
    required super.quantity,
    required super.subTotal,
    super.product,
    super.service,
    required super.createdAt,
    required super.updatedAt,
  });

  factory OrderItemModel.empty() {
    return OrderItemModel(
      id: '',
      itemType: ItemType.product,
      name: '',
      price: 0.0,
      quantity: 1,
      subTotal: 0.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] ?? '',
      itemType: ItemType.fromJson(json['itemType'] ?? 'product'),
      name: json['name'] ?? '',
      price: (json['price'] is String)
          ? double.parse(json['price'])
          : (json['price'] ?? 0.0).toDouble(),
      quantity: json['quantity'] ?? 1,
      subTotal: (json['subTotal'] is String)
          ? double.parse(json['subTotal'])
          : (json['subTotal'] ?? 0.0).toDouble(),
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'])
          : null,
      service: json['service'] != null
          ? ServiceModel.fromJson(json['service'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  factory OrderItemModel.fromEntity(OrderItem orderItem) {
    return OrderItemModel(
      id: orderItem.id,
      itemType: orderItem.itemType,
      name: orderItem.name,
      price: orderItem.price,
      quantity: orderItem.quantity,
      subTotal: orderItem.subTotal,
      product: orderItem.product,
      service: orderItem.service,
      createdAt: orderItem.createdAt,
      updatedAt: orderItem.updatedAt,
    );
  }

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      id: map['id'] ?? '',
      itemType: ItemType.fromJson(map['itemType'] ?? 'product'),
      name: map['name'] ?? '',
      price: (map['price'] is String)
          ? double.parse(map['price'])
          : (map['price'] ?? 0.0).toDouble(),
      quantity: map['quantity'] ?? 1,
      subTotal: (map['subTotal'] is String)
          ? double.parse(map['subTotal'])
          : (map['subTotal'] ?? 0.0).toDouble(),
      product: map['product'] != null
          ? ProductModel.fromMap(map['product'])
          : null,
      service: map['service'] != null
          ? ServiceModel.fromMap(map['service'])
          : null,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemType': itemType.toJson(),
      'name': name,
      'price': price,
      'quantity': quantity,
      'subTotal': subTotal,
      'product': product != null
          ? ProductModel.fromEntity(product!).toJson()
          : null,
      'service': service != null
          ? ServiceModel.fromEntity(service!).toJson()
          : null,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itemType': itemType.toJson(),
      'name': name,
      'price': price,
      'quantity': quantity,
      'subTotal': subTotal,
      'product': product != null
          ? ProductModel.fromEntity(product!).toMap()
          : null,
      'service': service != null
          ? ServiceModel.fromEntity(service!).toMap()
          : null,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  OrderItem toEntity() {
    return OrderItem(
      id: id,
      itemType: itemType,
      name: name,
      price: price,
      quantity: quantity,
      subTotal: subTotal,
      product: product,
      service: service,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
