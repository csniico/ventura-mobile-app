import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/models/failure/failure.dart';
import 'package:ventura/core/use_case/use_case.dart';

class GetCurrentUser implements UseCase<String, GetCurrentUserParams> {
  @override
  Future<Either<Failure, String>> call(GetCurrentUserParams params) async {
    debugPrint('Get Current User: ${params.uid}');
    return right(params.uid);
  }
}

class GetCurrentUserParams {
  final String uid;

  GetCurrentUserParams({required this.uid});
}
