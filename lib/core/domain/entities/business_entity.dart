class Business {
  final String id;
  final String shortId;
  final String ownerId;
  final String? email;
  final String? phone;
  final String name;
  final String? description;
  final String? tagLine;
  final List<String> categories;
  final String? logo;
  final String? city;
  final String? state;
  final String? country;
  final String? address;

  Business({
    required this.id,
    required this.shortId,
    required this.ownerId,
    required this.categories,
    required this.name,
    this.email,
    this.phone,
    this.description,
    this.tagLine,
    this.logo,
    this.city,
    this.state,
    this.country,
    this.address,
  });
}
