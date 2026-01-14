import 'order_item_entity.dart';
import 'order_status.dart';
import 'customer_entity.dart';

class Order {
  final String id;
  final String orderNumber;
  final String businessId;
  final String? customerId;
  final String? invoiceId;
  final OrderStatus status;
  final double totalAmount;
  final Customer? customer;
  final List<OrderItem> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.orderNumber,
    required this.businessId,
    this.customerId,
    this.invoiceId,
    required this.status,
    required this.totalAmount,
    this.customer,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  Order copyWith({
    String? id,
    String? orderNumber,
    String? businessId,
    String? customerId,
    String? invoiceId,
    OrderStatus? status,
    double? totalAmount,
    Customer? customer,
    List<OrderItem>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Order(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      businessId: businessId ?? this.businessId,
      customerId: customerId ?? this.customerId,
      invoiceId: invoiceId ?? this.invoiceId,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      customer: customer ?? this.customer,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Order &&
        other.id == id &&
        other.orderNumber == orderNumber &&
        other.businessId == businessId &&
        other.customerId == customerId &&
        other.invoiceId == invoiceId &&
        other.status == status &&
        other.totalAmount == totalAmount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        orderNumber.hashCode ^
        businessId.hashCode ^
        status.hashCode ^
        totalAmount.hashCode;
  }
}
