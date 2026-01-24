import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/sales/domain/entities/customer_entity.dart';
import 'package:ventura/features/sales/domain/repositories/customer_repository.dart';

class ImportCustomers
    implements UseCase<List<Customer>, ImportCustomersParams> {
  final CustomerRepository customerRepository;

  ImportCustomers({required this.customerRepository});

  @override
  Future<fpdart.Either<Failure, List<Customer>>> call(
    ImportCustomersParams params,
  ) async {
    return await customerRepository.importCustomers(
      businessId: params.businessId,
      customers: params.customers,
    );
  }
}

class ImportCustomersParams {
  final String businessId;
  final List<Map<String, dynamic>> customers;

  ImportCustomersParams({required this.businessId, required this.customers});
}
