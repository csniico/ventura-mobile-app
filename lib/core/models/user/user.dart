import 'package:ventura/core/models/business/business.dart';

class User {
  final String id;
  final String? shortId;
  final String firstName;
  final String? lastName;
  final String email;
  final String? googleId;
  final String? avatarUrl;
  final Business? employerBusiness;
  final bool isSystem;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  final List<dynamic>? roles;
  final List<dynamic>? directPermissions;
  final List<Business>? ownedBusinesses;
  final List<Business>? memberOfBusinesses;

  User({
    required this.id,
    required this.firstName,
    required this.email,
    required this.isSystem,
    this.lastName,
    this.shortId,
    this.googleId,
    this.avatarUrl,
    this.employerBusiness,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.roles,
    this.directPermissions,
    this.ownedBusinesses,
    this.memberOfBusinesses,
  });

  // -------- SQLite Converters --------
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      avatarUrl: map['avatarUrl'],
      googleId: map['googleId'],
      // The service layer is responsible for populating this complex object.
      employerBusiness: map['employerBusiness'] is Business ? map['employerBusiness'] : null,
      ownedBusinesses: map['ownedBusinesses'] is List<Business> ? map['ownedBusinesses'] : null,
      memberOfBusinesses: map['memberOfBusinesses'] is List<Business> ? map['memberOfBusinesses'] : null,
      isSystem: (map['isSystem'] ?? 0) == 1,
      isActive: (map['isActive'] ?? 0) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'avatarUrl': avatarUrl,
      'googleId': googleId,
      'employerBusiness': employerBusiness?.id, // Store only the ID
      'isSystem': isSystem ? 1 : 0,
      'isActive': isActive == true ? 1 : 0,
    };
  }

  // -------- JSON Converters --------
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      shortId: json['shortId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      googleId: json['googleId'],
      avatarUrl: json['avatarUrl'],
      employerBusiness: json['employerBusiness'] != null
          ? Business.fromJson(json['employerBusiness'])
          : null,
      isSystem: json['isSystem'] ?? false,
      isActive: json['isActive'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
      roles: json['roles'],
      directPermissions: json['directPermissions'],
      ownedBusinesses: json['ownedBusinesses'] != null
          ? List<Business>.from(
              json['ownedBusinesses'].map((x) => Business.fromJson(x)))
          : null,
      memberOfBusinesses: json['memberOfBusinesses'] != null
          ? List<Business>.from(
              json['memberOfBusinesses'].map((x) => Business.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shortId': shortId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'googleId': googleId,
      'avatarUrl': avatarUrl,
      'employerBusiness': employerBusiness?.toJson(),
      'isSystem': isSystem,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'roles': roles,
      'directPermissions': directPermissions,
      'ownedBusinesses': ownedBusinesses?.map((e) => e.toJson()).toList(),
      'memberOfBusinesses': memberOfBusinesses?.map((e) => e.toJson()).toList(),
    };
  }
}
