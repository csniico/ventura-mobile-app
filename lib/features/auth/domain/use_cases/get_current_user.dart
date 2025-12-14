import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/models/failure.dart';
import 'package:ventura/core/use_case/use_case.dart';
import 'package:ventura/core/entities/user_entity.dart';
import 'package:ventura/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUser implements UseCase<User, NoParams> {
  final AuthRepository authRepository;

  GetCurrentUser({required this.authRepository});
  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authRepository.getUser();
  }
}
