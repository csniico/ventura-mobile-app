import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/sales/domain/entities/customer_entity.dart';
import 'package:ventura/features/sales/domain/repositories/customer_repository.dart';

class UpdateCustomer implements UseCase<Customer, UpdateCustomerParams> {
  final CustomerRepository customerRepository;

  UpdateCustomer({required this.customerRepository});

  @override
  Future<fpdart.Either<Failure, Customer>> call(
    UpdateCustomerParams params,
  ) async {
    return await customerRepository.updateCustomer(
      customerId: params.customerId,
      businessId: params.businessId,
      name: params.name,
      email: params.email,
      phone: params.phone,
      notes: params.notes,
    );
  }
}

class UpdateCustomerParams {
  final String customerId;
  final String businessId;
  final String? name;
  final String? email;
  final String? phone;
  final String? notes;

  UpdateCustomerParams({
    required this.customerId,
    required this.businessId,
    this.name,
    this.email,
    this.phone,
    this.notes,
  });
}
