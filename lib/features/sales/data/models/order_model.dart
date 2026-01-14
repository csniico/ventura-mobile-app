import 'package:ventura/features/sales/domain/entities/order_entity.dart';
import 'package:ventura/features/sales/domain/entities/order_status.dart';
import 'package:ventura/features/sales/data/models/customer_model.dart';
import 'package:ventura/features/sales/data/models/order_item_model.dart';

class OrderModel extends Order {
  OrderModel({
    required super.id,
    required super.orderNumber,
    required super.businessId,
    super.customerId,
    super.invoiceId,
    required super.status,
    required super.totalAmount,
    super.customer,
    required super.items,
    required super.createdAt,
    required super.updatedAt,
  });

  factory OrderModel.empty() {
    return OrderModel(
      id: '',
      orderNumber: '',
      businessId: '',
      status: OrderStatus.pending,
      totalAmount: 0.0,
      items: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      orderNumber: json['orderNumber'] ?? '',
      businessId: json['businessId'] ?? '',
      customerId: json['customerId'],
      invoiceId: json['invoiceId'],
      status: OrderStatus.fromJson(json['status'] ?? 'pending'),
      totalAmount: (json['totalAmount'] is String)
          ? double.parse(json['totalAmount'])
          : (json['totalAmount'] ?? 0.0).toDouble(),
      customer: json['customer'] != null
          ? CustomerModel.fromJson(json['customer'])
          : null,
      items: json['items'] != null
          ? (json['items'] as List)
                .map((item) => OrderItemModel.fromJson(item))
                .toList()
          : [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  factory OrderModel.fromEntity(Order order) {
    return OrderModel(
      id: order.id,
      orderNumber: order.orderNumber,
      businessId: order.businessId,
      customerId: order.customerId,
      invoiceId: order.invoiceId,
      status: order.status,
      totalAmount: order.totalAmount,
      customer: order.customer,
      items: order.items,
      createdAt: order.createdAt,
      updatedAt: order.updatedAt,
    );
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? '',
      orderNumber: map['orderNumber'] ?? '',
      businessId: map['businessId'] ?? '',
      customerId: map['customerId'],
      invoiceId: map['invoiceId'],
      status: OrderStatus.fromJson(map['status'] ?? 'pending'),
      totalAmount: (map['totalAmount'] is String)
          ? double.parse(map['totalAmount'])
          : (map['totalAmount'] ?? 0.0).toDouble(),
      customer: map['customer'] != null
          ? CustomerModel.fromMap(map['customer'])
          : null,
      items: map['items'] != null
          ? (map['items'] as List)
                .map((item) => OrderItemModel.fromMap(item))
                .toList()
          : [],
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
      'orderNumber': orderNumber,
      'businessId': businessId,
      'customerId': customerId,
      'invoiceId': invoiceId,
      'status': status.toJson(),
      'totalAmount': totalAmount,
      'customer': customer != null
          ? CustomerModel.fromEntity(customer!).toJson()
          : null,
      'items': items
          .map((item) => OrderItemModel.fromEntity(item).toJson())
          .toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'businessId': businessId,
      'customerId': customerId,
      'invoiceId': invoiceId,
      'status': status.toJson(),
      'totalAmount': totalAmount,
      'customer': customer != null
          ? CustomerModel.fromEntity(customer!).toMap()
          : null,
      'items': items
          .map((item) => OrderItemModel.fromEntity(item).toMap())
          .toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Order toEntity() {
    return Order(
      id: id,
      orderNumber: orderNumber,
      businessId: businessId,
      customerId: customerId,
      invoiceId: invoiceId,
      status: status,
      totalAmount: totalAmount,
      customer: customer,
      items: items,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
