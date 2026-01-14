import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/sales/domain/entities/customer_entity.dart';
import 'package:ventura/features/sales/domain/repositories/customer_repository.dart';

class GetCustomers implements UseCase<List<Customer>, GetCustomersParams> {
  final CustomerRepository customerRepository;

  GetCustomers({required this.customerRepository});

  @override
  Future<fpdart.Either<Failure, List<Customer>>> call(
    GetCustomersParams params,
  ) async {
    return await customerRepository.getCustomers(
      businessId: params.businessId,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetCustomersParams {
  final String businessId;
  final int? page;
  final int? limit;

  GetCustomersParams({required this.businessId, this.page, this.limit});
}
