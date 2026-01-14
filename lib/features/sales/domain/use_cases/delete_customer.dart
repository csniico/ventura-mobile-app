import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/sales/domain/repositories/customer_repository.dart';

class DeleteCustomer implements UseCase<String, DeleteCustomerParams> {
  final CustomerRepository customerRepository;

  DeleteCustomer({required this.customerRepository});

  @override
  Future<fpdart.Either<Failure, String>> call(
    DeleteCustomerParams params,
  ) async {
    return await customerRepository.deleteCustomer(
      customerId: params.customerId,
      businessId: params.businessId,
    );
  }
}

class DeleteCustomerParams {
  final String customerId;
  final String businessId;

  DeleteCustomerParams({required this.customerId, required this.businessId});
}
