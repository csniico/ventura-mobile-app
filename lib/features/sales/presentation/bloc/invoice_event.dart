part of 'invoice_bloc.dart';

@immutable
sealed class InvoiceEvent {}

final class InvoiceCreateEvent extends InvoiceEvent {
  final String businessId;
  final String customerId;
  final List<String> orderIds;
  final DateTime? dueDate;
  final String? notes;

  InvoiceCreateEvent({
    required this.businessId,
    required this.customerId,
    required this.orderIds,
    this.dueDate,
    this.notes,
  });
}

final class InvoiceGetListEvent extends InvoiceEvent {
  final String businessId;
  final String? status;
  final String? customerId;
  final int? page;
  final int? limit;

  InvoiceGetListEvent({
    required this.businessId,
    this.status,
    this.customerId,
    this.page,
    this.limit,
  });
}

final class InvoiceGetCustomerInvoicesEvent extends InvoiceEvent {
  final String customerId;
  final String businessId;
  final int? page;
  final int? limit;

  InvoiceGetCustomerInvoicesEvent({
    required this.customerId,
    required this.businessId,
    this.page,
    this.limit,
  });
}

final class InvoiceGetByIdEvent extends InvoiceEvent {
  final String invoiceId;
  final String businessId;

  InvoiceGetByIdEvent({required this.invoiceId, required this.businessId});
}

final class InvoiceUpdatePaymentEvent extends InvoiceEvent {
  final String invoiceId;
  final String businessId;
  final double amountPaid;
  final String paymentMethod;
  final DateTime? paymentDate;

  InvoiceUpdatePaymentEvent({
    required this.invoiceId,
    required this.businessId,
    required this.amountPaid,
    required this.paymentMethod,
    this.paymentDate,
  });
}

final class InvoiceUpdateStatusEvent extends InvoiceEvent {
  final String invoiceId;
  final String businessId;
  final String status;

  InvoiceUpdateStatusEvent({
    required this.invoiceId,
    required this.businessId,
    required this.status,
  });
}
