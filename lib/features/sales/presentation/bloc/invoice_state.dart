part of 'invoice_bloc.dart';

@immutable
sealed class InvoiceState {}

final class InvoiceInitial extends InvoiceState {}

final class InvoiceLoadingState extends InvoiceState {}

final class InvoiceListLoadedState extends InvoiceState {
  final List<Invoice> invoices;

  InvoiceListLoadedState({required this.invoices});
}

final class InvoiceLoadedState extends InvoiceState {
  final Invoice invoice;

  InvoiceLoadedState({required this.invoice});
}

final class InvoiceCreateSuccessState extends InvoiceState {
  final Invoice invoice;

  InvoiceCreateSuccessState({required this.invoice});
}

final class InvoicePaymentUpdateSuccessState extends InvoiceState {
  final Invoice invoice;

  InvoicePaymentUpdateSuccessState({required this.invoice});
}

final class InvoiceStatusUpdateSuccessState extends InvoiceState {
  final Invoice invoice;

  InvoiceStatusUpdateSuccessState({required this.invoice});
}

final class InvoiceErrorState extends InvoiceState {
  final String message;

  InvoiceErrorState({required this.message});
}
