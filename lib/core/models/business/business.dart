class Business {
  final String id;
  final String name;
  final String? description;
  final String? email;
  final String? phone;
  final String? website;
  final String? logo;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? zipCode;
  final String ownerId;
  final bool isActive;

  Business({
    required this.id,
    required this.name,
    this.description,
    this.email,
    this.phone,
    this.website,
    this.logo,
    this.address,
    this.city,
    this.state,
    this.country,
    this.zipCode,
    required this.ownerId,
    required this.isActive,
  });

  // -------- JSON --------
  factory Business.fromJson(Map<String, dynamic> json) => Business(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    email: json["email"],
    phone: json["phone"],
    website: json["website"],
    logo: json["logo"],
    address: json["address"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    zipCode: json["zipCode"],
    ownerId: json["ownerId"],
    isActive: json["isActive"] ?? true,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "email": email,
    "phone": phone,
    "website": website,
    "logo": logo,
    "address": address,
    "city": city,
    "state": state,
    "country": country,
    "zipCode": zipCode,
    "ownerId": ownerId,
    "isActive": isActive,
  };

  // -------- SQLite --------
  factory Business.fromMap(Map<String, dynamic> map) => Business(
    id: map["id"],
    name: map["name"],
    description: map["description"],
    email: map["email"],
    phone: map["phone"],
    website: map["website"],
    logo: map["logo"],
    address: map["address"],
    city: map["city"],
    state: map["state"],
    country: map["country"],
    zipCode: map["zipCode"],
    ownerId: map["ownerId"],
    isActive: map["isActive"] == 1,
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "description": description,
    "email": email,
    "phone": phone,
    "website": website,
    "logo": logo,
    "address": address,
    "city": city,
    "state": state,
    "country": country,
    "zipCode": zipCode,
    "ownerId": ownerId,
    "isActive": isActive ? 1 : 0,
  };
}
