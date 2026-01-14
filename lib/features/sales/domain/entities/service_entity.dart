class Service {
  final String id;
  final String shortId;
  final String name;
  final String? primaryImage;
  final List<String>? supportingImages;
  final String businessId;
  final String? description;
  final String? notes;
  final double price;
  final Map<String, dynamic>? businessHours;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Service({
    required this.id,
    required this.shortId,
    required this.name,
    this.primaryImage,
    this.supportingImages,
    required this.businessId,
    this.description,
    this.notes,
    required this.price,
    this.businessHours,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  Service copyWith({
    String? id,
    String? shortId,
    String? name,
    String? primaryImage,
    List<String>? supportingImages,
    String? businessId,
    String? description,
    String? notes,
    double? price,
    Map<String, dynamic>? businessHours,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return Service(
      id: id ?? this.id,
      shortId: shortId ?? this.shortId,
      name: name ?? this.name,
      primaryImage: primaryImage ?? this.primaryImage,
      supportingImages: supportingImages ?? this.supportingImages,
      businessId: businessId ?? this.businessId,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      price: price ?? this.price,
      businessHours: businessHours ?? this.businessHours,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Service &&
        other.id == id &&
        other.shortId == shortId &&
        other.name == name &&
        other.primaryImage == primaryImage &&
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
        businessId.hashCode ^
        price.hashCode;
  }
}
