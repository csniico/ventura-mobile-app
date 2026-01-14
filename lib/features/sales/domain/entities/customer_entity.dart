class Customer {
  final String id;
  final String shortId;
  final String businessId;
  final String name;
  final String? email;
  final String? phone;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Customer({
    required this.id,
    required this.shortId,
    required this.businessId,
    required this.name,
    this.email,
    this.phone,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  Customer copyWith({
    String? id,
    String? shortId,
    String? businessId,
    String? name,
    String? email,
    String? phone,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return Customer(
      id: id ?? this.id,
      shortId: shortId ?? this.shortId,
      businessId: businessId ?? this.businessId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Customer &&
        other.id == id &&
        other.shortId == shortId &&
        other.businessId == businessId &&
        other.name == name &&
        other.email == email &&
        other.phone == phone;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        shortId.hashCode ^
        businessId.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phone.hashCode;
  }
}
