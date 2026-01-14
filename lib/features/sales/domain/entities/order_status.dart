enum OrderStatus {
  pending,
  completed,
  cancelled;

  String toJson() => name;

  static OrderStatus fromJson(String json) {
    return OrderStatus.values.firstWhere(
      (status) => status.name.toLowerCase() == json.toLowerCase(),
      orElse: () => OrderStatus.pending,
    );
  }
}
