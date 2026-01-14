import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/features/sales/domain/entities/invoice_entity.dart';

abstract interface class InvoiceRepository {
  Future<fpdart.Either<Failure, Invoice>> createInvoice({
    required String businessId,
    required String customerId,
    required List<String> orderIds,
    DateTime? dueDate,
    String? notes,
  });

  Future<fpdart.Either<Failure, List<Invoice>>> getInvoices({
    required String businessId,
    String? status,
    String? customerId,
    int? page,
    int? limit,
  });

  Future<fpdart.Either<Failure, List<Invoice>>> getCustomerInvoices({
    required String customerId,
    required String businessId,
    int? page,
    int? limit,
  });

  Future<fpdart.Either<Failure, Invoice>> getInvoiceById({
    required String invoiceId,
    required String businessId,
  });

  Future<fpdart.Either<Failure, Invoice>> updateInvoicePayment({
    required String invoiceId,
    required String businessId,
    required double amountPaid,
    required String paymentMethod,
    DateTime? paymentDate,
  });

  Future<fpdart.Either<Failure, Invoice>> updateInvoiceStatus({
    required String invoiceId,
    required String businessId,
    required String status,
  });
}
