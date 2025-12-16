import 'package:ventura/core/data/models/user_model.dart';
import 'package:ventura/features/auth/domain/entities/server_sign_up.dart';

class ServerSignUpModel extends ServerSignUp {
  ServerSignUpModel({required super.user, required super.shortToken});

  factory ServerSignUpModel.fromJson(Map<String, dynamic> map) {
    return ServerSignUpModel(
      user: UserModel.fromJson(map['user']),
      shortToken: map['shortToken'] ?? '',
    );
  }
}
