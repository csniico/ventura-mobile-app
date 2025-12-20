class User {
  final String id;
  final String googleId;
  final String shortId;
  final String email;
  final String firstName;
  final String? lastName;
  final String? avatarUrl;
  final bool isSystem;
  final bool isActive;
  final bool isEmailVerified;
  final String businessId;

  User({
    required this.id,
    required this.googleId,
    required this.shortId,
    required this.email,
    required this.firstName,
    required this.isSystem,
    required this.isActive,
    required this.isEmailVerified,
    required this.businessId,
    this.lastName,
    this.avatarUrl,
  });

  User copyWith({
    String? id,
    String? email,
    String? googleId,
    String? shortId,
    String? firstName,
    bool? isSystem,
    bool? isActive,
    bool? isEmailVerified,
    String? businessId,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      googleId: googleId ?? this.googleId,
      shortId: shortId ?? this.shortId,
      firstName: firstName ?? this.firstName,
      isSystem: isSystem ?? this.isSystem,
      isActive: isActive ?? this.isActive,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      businessId: businessId ?? this.businessId,
    );
  }
}
