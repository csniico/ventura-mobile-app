part of 'customer_bloc.dart';

@immutable
sealed class CustomerState {}

final class CustomerInitial extends CustomerState {}

final class CustomerLoadingState extends CustomerState {}

final class CustomerListLoadedState extends CustomerState {
  final List<Customer> customers;

  CustomerListLoadedState({required this.customers});
}

final class CustomerLoadedState extends CustomerState {
  final Customer customer;

  CustomerLoadedState({required this.customer});
}

final class CustomerCreateSuccessState extends CustomerState {
  final Customer customer;

  CustomerCreateSuccessState({required this.customer});
}

final class CustomerUpdateSuccessState extends CustomerState {
  final Customer customer;

  CustomerUpdateSuccessState({required this.customer});
}

final class CustomerDeleteSuccessState extends CustomerState {
  final String message;

  CustomerDeleteSuccessState({required this.message});
}

final class CustomerErrorState extends CustomerState {
  final String message;

  CustomerErrorState({required this.message});
}
