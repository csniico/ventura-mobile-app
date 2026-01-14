class Product {
  final String id;
  final String shortId;
  final String name;
  final String? primaryImage;
  final List<String>? supportingImages;
  final int availableQuantity;
  final String businessId;
  final String? description;
  final String? notes;
  final double price;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Product({
    required this.id,
    required this.shortId,
    required this.name,
    this.primaryImage,
    this.supportingImages,
    required this.availableQuantity,
    required this.businessId,
    this.description,
    this.notes,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  Product copyWith({
    String? id,
    String? shortId,
    String? name,
    String? primaryImage,
    List<String>? supportingImages,
    int? availableQuantity,
    String? businessId,
    String? description,
    String? notes,
    double? price,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return Product(
      id: id ?? this.id,
      shortId: shortId ?? this.shortId,
      name: name ?? this.name,
      primaryImage: primaryImage ?? this.primaryImage,
      supportingImages: supportingImages ?? this.supportingImages,
      availableQuantity: availableQuantity ?? this.availableQuantity,
      businessId: businessId ?? this.businessId,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.id == id &&
        other.shortId == shortId &&
        other.name == name &&
        other.primaryImage == primaryImage &&
        other.availableQuantity == availableQuantity &&
        other.businessId == businessId &&
        other.description == description &&
        other.notes == notes &&
        other.price == price;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        shortId.hashCode ^
        name.hashCode ^
        primaryImage.hashCode ^
        availableQuantity.hashCode ^
        businessId.hashCode ^
        price.hashCode;
  }
}
