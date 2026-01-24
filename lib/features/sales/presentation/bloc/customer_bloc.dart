import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventura/features/sales/domain/entities/customer_entity.dart';
import 'package:ventura/features/sales/domain/use_cases/create_customer.dart';
import 'package:ventura/features/sales/domain/use_cases/delete_customer.dart';
import 'package:ventura/features/sales/domain/use_cases/get_customer_by_id.dart';
import 'package:ventura/features/sales/domain/use_cases/get_customers.dart';
import 'package:ventura/features/sales/domain/use_cases/update_customer.dart';
import 'package:ventura/features/sales/domain/use_cases/import_customers.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final GetCustomers _getCustomers;
  final GetCustomerById _getCustomerById;
  final CreateCustomer _createCustomer;
  final UpdateCustomer _updateCustomer;
  final DeleteCustomer _deleteCustomer;
  final ImportCustomers _importCustomers;

  CustomerBloc({
    required GetCustomers getCustomers,
    required GetCustomerById getCustomerById,
    required CreateCustomer createCustomer,
    required UpdateCustomer updateCustomer,
    required DeleteCustomer deleteCustomer,
    required ImportCustomers importCustomers,
  }) : _getCustomers = getCustomers,
       _getCustomerById = getCustomerById,
       _createCustomer = createCustomer,
       _updateCustomer = updateCustomer,
       _deleteCustomer = deleteCustomer,
       _importCustomers = importCustomers,
       super(CustomerInitial()) {
    on<CustomerEvent>((event, emit) => emit(CustomerLoadingState()));
    on<CustomerGetEvent>(_onCustomerGetEvent);
    on<CustomerGetByIdEvent>(_onCustomerGetByIdEvent);
    on<CustomerCreateEvent>(_onCustomerCreateEvent);
    on<CustomerUpdateEvent>(_onCustomerUpdateEvent);
    on<CustomerDeleteEvent>(_onCustomerDeleteEvent);
    on<CustomerImportEvent>(_onCustomerImportEvent);
  }

  void _onCustomerGetEvent(
    CustomerGetEvent event,
    Emitter<CustomerState> emit,
  ) async {
    final res = await _getCustomers(
      GetCustomersParams(
        businessId: event.businessId,
        page: event.page,
        limit: event.limit,
      ),
    );

    res.fold(
      (failure) => emit(CustomerErrorState(message: failure.message)),
      (customers) => emit(CustomerListLoadedState(customers: customers)),
    );
  }

  void _onCustomerGetByIdEvent(
    CustomerGetByIdEvent event,
    Emitter<CustomerState> emit,
  ) async {
    final res = await _getCustomerById(
      GetCustomerByIdParams(
        customerId: event.customerId,
        businessId: event.businessId,
      ),
    );

    res.fold(
      (failure) => emit(CustomerErrorState(message: failure.message)),
      (customer) => emit(CustomerLoadedState(customer: customer)),
    );
  }

  void _onCustomerCreateEvent(
    CustomerCreateEvent event,
    Emitter<CustomerState> emit,
  ) async {
    final res = await _createCustomer(
      CreateCustomerParams(
        businessId: event.businessId,
        name: event.name,
        email: event.email,
        phone: event.phone,
        notes: event.notes,
      ),
    );

    res.fold(
      (failure) => emit(CustomerErrorState(message: failure.message)),
      (customer) => emit(CustomerCreateSuccessState(customer: customer)),
    );
  }

  void _onCustomerUpdateEvent(
    CustomerUpdateEvent event,
    Emitter<CustomerState> emit,
  ) async {
    final res = await _updateCustomer(
      UpdateCustomerParams(
        customerId: event.customerId,
        businessId: event.businessId,
        name: event.name,
        email: event.email,
        phone: event.phone,
        notes: event.notes,
      ),
    );

    res.fold(
      (failure) => emit(CustomerErrorState(message: failure.message)),
      (customer) => emit(CustomerUpdateSuccessState(customer: customer)),
    );
  }

  void _onCustomerDeleteEvent(
    CustomerDeleteEvent event,
    Emitter<CustomerState> emit,
  ) async {
    final res = await _deleteCustomer(
      DeleteCustomerParams(
        customerId: event.customerId,
        businessId: event.businessId,
      ),
    );

    res.fold(
      (failure) => emit(CustomerErrorState(message: failure.message)),
      (message) => emit(CustomerDeleteSuccessState(message: message)),
    );
  }

  void _onCustomerImportEvent(
    CustomerImportEvent event,
    Emitter<CustomerState> emit,
  ) async {
    final res = await _importCustomers(
      ImportCustomersParams(
        businessId: event.businessId,
        customers: event.customers,
      ),
    );

    res.fold(
      (failure) => emit(CustomerErrorState(message: failure.message)),
      (importedCustomers) => emit(
        CustomerImportSuccessState(importedCustomers: importedCustomers),
      ),
    );
  }
}
