enum ItemType {
  product,
  service;

  String toJson() => name;

  static ItemType fromJson(String json) {
    return ItemType.values.firstWhere(
      (type) => type.name.toLowerCase() == json.toLowerCase(),
      orElse: () => ItemType.product,
    );
  }
}
