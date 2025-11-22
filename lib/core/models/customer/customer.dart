class Customer {
  final String id;
  final String firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? avatar;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? zipCode;
  final String businessId;
  final bool isActive;

  Customer({
    required this.id,
    required this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.avatar,
    this.address,
    this.city,
    this.state,
    this.country,
    this.zipCode,
    required this.businessId,
    required this.isActive,
  });

  // -------- JSON --------
  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
    phone: json["phone"],
    avatar: json["avatar"],
    address: json["address"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    zipCode: json["zipCode"],
    businessId: json["businessId"],
    isActive: json["isActive"] ?? true,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "phone": phone,
    "avatar": avatar,
    "address": address,
    "city": city,
    "state": state,
    "country": country,
    "zipCode": zipCode,
    "businessId": businessId,
    "isActive": isActive,
  };

  // -------- SQLite --------
  factory Customer.fromMap(Map<String, dynamic> map) => Customer(
    id: map["id"],
    firstName: map["firstName"],
    lastName: map["lastName"],
    email: map["email"],
    phone: map["phone"],
    avatar: map["avatar"],
    address: map["address"],
    city: map["city"],
    state: map["state"],
    country: map["country"],
    zipCode: map["zipCode"],
    businessId: map["businessId"],
    isActive: map["isActive"] == 1,
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "phone": phone,
    "avatar": avatar,
    "address": address,
    "city": city,
    "state": state,
    "country": country,
    "zipCode": zipCode,
    "businessId": businessId,
    "isActive": isActive ? 1 : 0,
  };
}
