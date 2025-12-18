import 'package:ventura/core/domain/entities/user_entity.dart';

class ServerSignUp {
  final User user;
  final String shortToken;

  ServerSignUp({required this.user, required this.shortToken});
}
