import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/features/sales/domain/entities/customer_entity.dart';

abstract interface class CustomerRepository {
  Future<fpdart.Either<Failure, List<Customer>>> getCustomers({
    required String businessId,
    int? page,
    int? limit,
  });

  Future<fpdart.Either<Failure, Customer>> getCustomerById({
    required String customerId,
    required String businessId,
  });

  Future<fpdart.Either<Failure, Customer>> createCustomer({
    required String businessId,
    required String name,
    String? email,
    String? phone,
    String? notes,
  });

  Future<fpdart.Either<Failure, Customer>> updateCustomer({
    required String customerId,
    required String businessId,
    String? name,
    String? email,
    String? phone,
    String? notes,
  });

  Future<fpdart.Either<Failure, String>> deleteCustomer({
    required String customerId,
    required String businessId,
  });
}
