import 'package:ventura/core/entities/user_entity.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.googleId,
    required super.shortId,
    required super.email,
    required super.firstName,
    required super.isSystem,
    required super.isActive,
    required super.isEmailVerified,
    required super.ownedBusinesses,
    super.lastName,
    super.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      googleId: map['googleId'] ?? '',
      shortId: map['shortId'] ?? '',
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      avatarUrl: map['avatarUrl'] ?? '',
      isSystem: map['isSystem'] ?? false,
      isActive: map['isActive'] ?? false,
      isEmailVerified: map['isEmailVerified'] ?? false,
      ownedBusinesses: map['ownedBusinesses'] ?? [],
    );
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      googleId: user.googleId,
      shortId: user.shortId,
      email: user.email,
      firstName: user.firstName,
      isSystem: user.isSystem,
      isActive: user.isActive,
      isEmailVerified: user.isEmailVerified,
      ownedBusinesses: user.ownedBusinesses,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shortId': shortId,
      'googleId': googleId,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'avatarUrl': avatarUrl,
      'isSystem': isSystem,
      'isActive': isActive,
      'isEmailVerified': isEmailVerified,
      'ownedBusinesses': ownedBusinesses,
    };
  }
}
