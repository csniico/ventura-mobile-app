import 'package:ventura/features/sales/data/models/customer_model.dart';

abstract interface class CustomerRemoteDataSource {
  Future<List<CustomerModel>?> getCustomers({
    required String businessId,
    int? page,
    int? limit,
  });

  Future<CustomerModel?> getCustomerById({
    required String customerId,
    required String businessId,
  });

  Future<CustomerModel?> createCustomer({
    required String businessId,
    required String name,
    String? email,
    String? phone,
    String? notes,
  });

  Future<CustomerModel?> updateCustomer({
    required String customerId,
    required String businessId,
    String? name,
    String? email,
    String? phone,
    String? notes,
  });

  Future<String?> deleteCustomer({
    required String customerId,
    required String businessId,
  });
}
