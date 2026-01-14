import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/config/app_logger.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/features/sales/data/data_sources/remote/abstract_interfaces/customer_remote_data_source.dart';
import 'package:ventura/features/sales/domain/entities/customer_entity.dart';
import 'package:ventura/features/sales/domain/repositories/customer_repository.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerRemoteDataSource customerRemoteDataSource;
  final logger = AppLogger('CustomerRepositoryImpl');

  CustomerRepositoryImpl({required this.customerRemoteDataSource});

  @override
  Future<fpdart.Either<Failure, List<Customer>>> getCustomers({
    required String businessId,
    int? page,
    int? limit,
  }) async {
    try {
      final customers = await customerRemoteDataSource.getCustomers(
        businessId: businessId,
        page: page,
        limit: limit,
      );
      if (customers == null) {
        return fpdart.left(Failure('Failed to fetch customers'));
      }
      return fpdart.right(customers.map((model) => model.toEntity()).toList());
    } catch (e) {
      logger.error('Error fetching customers: $e');
      return fpdart.left(Failure('Failed to fetch customers'));
    }
  }

  @override
  Future<fpdart.Either<Failure, Customer>> getCustomerById({
    required String customerId,
    required String businessId,
  }) async {
    try {
      final customer = await customerRemoteDataSource.getCustomerById(
        customerId: customerId,
        businessId: businessId,
      );
      if (customer == null) {
        return fpdart.left(Failure('Customer not found'));
      }
      return fpdart.right(customer.toEntity());
    } catch (e) {
      logger.error('Error fetching customer: $e');
      return fpdart.left(Failure('Failed to fetch customer'));
    }
  }

  @override
  Future<fpdart.Either<Failure, Customer>> createCustomer({
    required String businessId,
    required String name,
    String? email,
    String? phone,
    String? notes,
  }) async {
    try {
      final customer = await customerRemoteDataSource.createCustomer(
        businessId: businessId,
        name: name,
        email: email,
        phone: phone,
        notes: notes,
      );
      if (customer == null) {
        return fpdart.left(Failure('Failed to create customer'));
      }
      return fpdart.right(customer.toEntity());
    } catch (e) {
      logger.error('Error creating customer: $e');
      return fpdart.left(Failure('Failed to create customer'));
    }
  }

  @override
  Future<fpdart.Either<Failure, Customer>> updateCustomer({
    required String customerId,
    required String businessId,
    String? name,
    String? email,
    String? phone,
    String? notes,
  }) async {
    try {
      final customer = await customerRemoteDataSource.updateCustomer(
        customerId: customerId,
        businessId: businessId,
        name: name,
        email: email,
        phone: phone,
        notes: notes,
      );
      if (customer == null) {
        return fpdart.left(Failure('Failed to update customer'));
      }
      return fpdart.right(customer.toEntity());
    } catch (e) {
      logger.error('Error updating customer: $e');
      return fpdart.left(Failure('Failed to update customer'));
    }
  }

  @override
  Future<fpdart.Either<Failure, String>> deleteCustomer({
    required String customerId,
    required String businessId,
  }) async {
    try {
      final result = await customerRemoteDataSource.deleteCustomer(
        customerId: customerId,
        businessId: businessId,
      );
      if (result == null) {
        return fpdart.left(Failure('Failed to delete customer'));
      }
      return fpdart.right(result);
    } catch (e) {
      logger.error('Error deleting customer: $e');
      return fpdart.left(Failure('Failed to delete customer'));
    }
  }
}
