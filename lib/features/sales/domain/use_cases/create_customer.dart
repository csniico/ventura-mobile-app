import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/sales/domain/entities/customer_entity.dart';
import 'package:ventura/features/sales/domain/repositories/customer_repository.dart';

class CreateCustomer implements UseCase<Customer, CreateCustomerParams> {
  final CustomerRepository customerRepository;

  CreateCustomer({required this.customerRepository});

  @override
  Future<fpdart.Either<Failure, Customer>> call(
    CreateCustomerParams params,
  ) async {
    return await customerRepository.createCustomer(
      businessId: params.businessId,
      name: params.name,
      email: params.email,
      phone: params.phone,
      notes: params.notes,
    );
  }
}

class CreateCustomerParams {
  final String businessId;
  final String name;
  final String? email;
  final String? phone;
  final String? notes;

  CreateCustomerParams({
    required this.businessId,
    required this.name,
    this.email,
    this.phone,
    this.notes,
  });
}
