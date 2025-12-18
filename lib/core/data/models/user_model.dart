import 'package:ventura/core/domain/entities/user_entity.dart';

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
    required super.businessId,
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
      isSystem: map['isSystem'] == 0 || map['isSystem'] == false ? false : true,
      isActive: map['isActive'] == 0 || map['isActive'] == false ? false : true,
      isEmailVerified: map['isEmailVerified'] == 0 || map['isEmailVerified'] == false ? false : true,
      businessId: map['businessId'] ?? '',
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
      businessId: user.businessId,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      googleId: map['googleId'] ?? '',
      shortId: map['shortId'] ?? '',
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      avatarUrl: map['avatarUrl'] ?? '',
      isSystem: map['isSystem'] == 0 || map['isSystem'] == false ? false : true,
      isActive: map['isActive'] == 0 || map['isActive'] == false ? false : true,
      isEmailVerified: map['isEmailVerified'] == 0 || map['isEmailVerified'] == false ? false : true,
      businessId: map['businessId'] ?? '',
    );
  }

  User toEntity() {
    return User(
      id: id,
      shortId: shortId,
      googleId: googleId,
      businessId: businessId,
      email: email,
      firstName: firstName,
      lastName: lastName,
      avatarUrl: avatarUrl,
      isActive: isActive,
      isEmailVerified: isEmailVerified,
      isSystem: isSystem,
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
      'isSystem': isSystem ? 1 : 0,
      'isActive': isActive ? 1 : 0,
      'isEmailVerified': isEmailVerified ? 1 : 0,
      'businessId': businessId,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shortId': shortId,
      'googleId': googleId,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'avatarUrl': avatarUrl,
      'isSystem': isSystem ? 1 : 0,
      'isActive': isActive ? 1 : 0,
      'isEmailVerified': isEmailVerified ? 1 : 0,
      'businessId': businessId,
    };
  }
}
