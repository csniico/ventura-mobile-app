import 'package:ventura/features/sales/data/models/invoice_model.dart';

abstract interface class InvoiceRemoteDataSource {
  Future<InvoiceModel?> createInvoice({
    required String businessId,
    required String customerId,
    required List<String> orderIds,
    DateTime? dueDate,
    String? notes,
  });

  Future<List<InvoiceModel>?> getInvoices({
    required String businessId,
    String? status,
    String? customerId,
    int? page,
    int? limit,
  });

  Future<List<InvoiceModel>?> getCustomerInvoices({
    required String customerId,
    required String businessId,
    int? page,
    int? limit,
  });

  Future<InvoiceModel?> getInvoiceById({
    required String invoiceId,
    required String businessId,
  });

  Future<InvoiceModel?> updateInvoicePayment({
    required String invoiceId,
    required String businessId,
    required double amountPaid,
    required String paymentMethod,
    DateTime? paymentDate,
  });

  Future<InvoiceModel?> updateInvoiceStatus({
    required String invoiceId,
    required String businessId,
    required String status,
  });
}
