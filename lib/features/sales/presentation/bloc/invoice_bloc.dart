import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventura/features/sales/domain/entities/invoice_entity.dart';
import 'package:ventura/features/sales/domain/use_cases/create_invoice.dart';
import 'package:ventura/features/sales/domain/use_cases/get_customer_invoices.dart';
import 'package:ventura/features/sales/domain/use_cases/get_invoice_by_id.dart';
import 'package:ventura/features/sales/domain/use_cases/get_invoices.dart';
import 'package:ventura/features/sales/domain/use_cases/update_invoice_payment.dart';
import 'package:ventura/features/sales/domain/use_cases/update_invoice_status.dart';

part 'invoice_event.dart';
part 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final CreateInvoice _createInvoice;
  final GetInvoices _getInvoices;
  final GetCustomerInvoices _getCustomerInvoices;
  final GetInvoiceById _getInvoiceById;
  final UpdateInvoicePayment _updateInvoicePayment;
  final UpdateInvoiceStatus _updateInvoiceStatus;

  InvoiceBloc({
    required CreateInvoice createInvoice,
    required GetInvoices getInvoices,
    required GetCustomerInvoices getCustomerInvoices,
    required GetInvoiceById getInvoiceById,
    required UpdateInvoicePayment updateInvoicePayment,
    required UpdateInvoiceStatus updateInvoiceStatus,
  }) : _createInvoice = createInvoice,
       _getInvoices = getInvoices,
       _getCustomerInvoices = getCustomerInvoices,
       _getInvoiceById = getInvoiceById,
       _updateInvoicePayment = updateInvoicePayment,
       _updateInvoiceStatus = updateInvoiceStatus,
       super(InvoiceInitial()) {
    on<InvoiceEvent>((event, emit) => emit(InvoiceLoadingState()));
    on<InvoiceCreateEvent>(_onInvoiceCreateEvent);
    on<InvoiceGetListEvent>(_onInvoiceGetListEvent);
    on<InvoiceGetCustomerInvoicesEvent>(_onInvoiceGetCustomerInvoicesEvent);
    on<InvoiceGetByIdEvent>(_onInvoiceGetByIdEvent);
    on<InvoiceUpdatePaymentEvent>(_onInvoiceUpdatePaymentEvent);
    on<InvoiceUpdateStatusEvent>(_onInvoiceUpdateStatusEvent);
  }

  void _onInvoiceCreateEvent(
    InvoiceCreateEvent event,
    Emitter<InvoiceState> emit,
  ) async {
    final res = await _createInvoice(
      CreateInvoiceParams(
        businessId: event.businessId,
        customerId: event.customerId,
        orderIds: event.orderIds,
        dueDate: event.dueDate,
        notes: event.notes,
      ),
    );

    res.fold(
      (failure) => emit(InvoiceErrorState(message: failure.message)),
      (invoice) => emit(InvoiceCreateSuccessState(invoice: invoice)),
    );
  }

  void _onInvoiceGetListEvent(
    InvoiceGetListEvent event,
    Emitter<InvoiceState> emit,
  ) async {
    final res = await _getInvoices(
      GetInvoicesParams(
        businessId: event.businessId,
        status: event.status,
        customerId: event.customerId,
        page: event.page,
        limit: event.limit,
      ),
    );

    res.fold(
      (failure) => emit(InvoiceErrorState(message: failure.message)),
      (invoices) => emit(InvoiceListLoadedState(invoices: invoices)),
    );
  }

  void _onInvoiceGetCustomerInvoicesEvent(
    InvoiceGetCustomerInvoicesEvent event,
    Emitter<InvoiceState> emit,
  ) async {
    final res = await _getCustomerInvoices(
      GetCustomerInvoicesParams(
        customerId: event.customerId,
        businessId: event.businessId,
        page: event.page,
        limit: event.limit,
      ),
    );

    res.fold(
      (failure) => emit(InvoiceErrorState(message: failure.message)),
      (invoices) => emit(InvoiceListLoadedState(invoices: invoices)),
    );
  }

  void _onInvoiceGetByIdEvent(
    InvoiceGetByIdEvent event,
    Emitter<InvoiceState> emit,
  ) async {
    final res = await _getInvoiceById(
      GetInvoiceByIdParams(
        invoiceId: event.invoiceId,
        businessId: event.businessId,
      ),
    );

    res.fold(
      (failure) => emit(InvoiceErrorState(message: failure.message)),
      (invoice) => emit(InvoiceLoadedState(invoice: invoice)),
    );
  }

  void _onInvoiceUpdatePaymentEvent(
    InvoiceUpdatePaymentEvent event,
    Emitter<InvoiceState> emit,
  ) async {
    final res = await _updateInvoicePayment(
      UpdateInvoicePaymentParams(
        invoiceId: event.invoiceId,
        businessId: event.businessId,
        amountPaid: event.amountPaid,
        paymentMethod: event.paymentMethod,
        paymentDate: event.paymentDate,
      ),
    );

    res.fold(
      (failure) => emit(InvoiceErrorState(message: failure.message)),
      (invoice) => emit(InvoicePaymentUpdateSuccessState(invoice: invoice)),
    );
  }

  void _onInvoiceUpdateStatusEvent(
    InvoiceUpdateStatusEvent event,
    Emitter<InvoiceState> emit,
  ) async {
    final res = await _updateInvoiceStatus(
      UpdateInvoiceStatusParams(
        invoiceId: event.invoiceId,
        businessId: event.businessId,
        status: event.status,
      ),
    );

    res.fold(
      (failure) => emit(InvoiceErrorState(message: failure.message)),
      (invoice) => emit(InvoiceStatusUpdateSuccessState(invoice: invoice)),
    );
  }
}
