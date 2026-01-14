import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/sales/domain/entities/customer_entity.dart';
import 'package:ventura/features/sales/domain/repositories/customer_repository.dart';

class GetCustomerById implements UseCase<Customer, GetCustomerByIdParams> {
  final CustomerRepository customerRepository;

  GetCustomerById({required this.customerRepository});

  @override
  Future<fpdart.Either<Failure, Customer>> call(
    GetCustomerByIdParams params,
  ) async {
    return await customerRepository.getCustomerById(
      customerId: params.customerId,
      businessId: params.businessId,
    );
  }
}

class GetCustomerByIdParams {
  final String customerId;
  final String businessId;

  GetCustomerByIdParams({required this.customerId, required this.businessId});
}
