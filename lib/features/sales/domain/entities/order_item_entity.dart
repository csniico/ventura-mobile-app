import 'item_type.dart';
import 'product_entity.dart';
import 'service_entity.dart';

class OrderItem {
  final String id;
  final ItemType itemType;
  final String name;
  final double price;
  final int quantity;
  final double subTotal;
  final Product? product;
  final Service? service;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderItem({
    required this.id,
    required this.itemType,
    required this.name,
    required this.price,
    required this.quantity,
    required this.subTotal,
    this.product,
    this.service,
    required this.createdAt,
    required this.updatedAt,
  });

  OrderItem copyWith({
    String? id,
    ItemType? itemType,
    String? name,
    double? price,
    int? quantity,
    double? subTotal,
    Product? product,
    Service? service,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderItem(
      id: id ?? this.id,
      itemType: itemType ?? this.itemType,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      subTotal: subTotal ?? this.subTotal,
      product: product ?? this.product,
      service: service ?? this.service,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderItem &&
        other.id == id &&
        other.itemType == itemType &&
        other.name == name &&
        other.price == price &&
        other.quantity == quantity &&
        other.subTotal == subTotal;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        itemType.hashCode ^
        name.hashCode ^
        price.hashCode ^
        quantity.hashCode ^
        subTotal.hashCode;
  }
}
