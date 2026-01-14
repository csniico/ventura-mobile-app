part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}

final class ProductSearchEvent extends ProductEvent {
  final String businessId;
  final String searchQuery;
  final double? minPrice;
  final double? maxPrice;
  final int? minQty;
  final int? page;
  final int? limit;

  ProductSearchEvent({
    required this.businessId,
    required this.searchQuery,
    this.minPrice,
    this.maxPrice,
    this.minQty,
    this.page,
    this.limit,
  });
}

final class ProductGetByIdEvent extends ProductEvent {
  final String productId;
  final String businessId;

  ProductGetByIdEvent({required this.productId, required this.businessId});
}

final class ProductCreateEvent extends ProductEvent {
  final String businessId;
  final String name;
  final double price;
  final int availableQuantity;
  final String? primaryImage;
  final List<String>? supportingImages;
  final String? description;
  final String? notes;

  ProductCreateEvent({
    required this.businessId,
    required this.name,
    required this.price,
    required this.availableQuantity,
    this.primaryImage,
    this.supportingImages,
    this.description,
    this.notes,
  });
}

final class ProductUpdateEvent extends ProductEvent {
  final String productId;
  final String businessId;
  final String? name;
  final double? price;
  final int? availableQuantity;
  final String? primaryImage;
  final List<String>? supportingImages;
  final String? description;
  final String? notes;

  ProductUpdateEvent({
    required this.productId,
    required this.businessId,
    this.name,
    this.price,
    this.availableQuantity,
    this.primaryImage,
    this.supportingImages,
    this.description,
    this.notes,
  });
}

final class ProductDeleteEvent extends ProductEvent {
  final String productId;
  final String businessId;

  ProductDeleteEvent({required this.productId, required this.businessId});
}
