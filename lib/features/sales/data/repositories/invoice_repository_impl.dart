import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/config/app_logger.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/features/sales/data/data_sources/remote/abstract_interfaces/invoice_remote_data_source.dart';
import 'package:ventura/features/sales/domain/entities/invoice_entity.dart';
import 'package:ventura/features/sales/domain/repositories/invoice_repository.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final InvoiceRemoteDataSource invoiceRemoteDataSource;
  final logger = AppLogger('InvoiceRepositoryImpl');

  InvoiceRepositoryImpl({required this.invoiceRemoteDataSource});

  @override
  Future<fpdart.Either<Failure, Invoice>> createInvoice({
    required String businessId,
    required String customerId,
    required List<String> orderIds,
    DateTime? dueDate,
    String? notes,
  }) async {
    try {
      final invoice = await invoiceRemoteDataSource.createInvoice(
        businessId: businessId,
        customerId: customerId,
        orderIds: orderIds,
        dueDate: dueDate,
        notes: notes,
      );
      if (invoice == null) {
        return fpdart.left(Failure('Failed to create invoice'));
      }
      return fpdart.right(invoice.toEntity());
    } catch (e) {
      logger.error('Error creating invoice: $e');
      return fpdart.left(Failure('Failed to create invoice'));
    }
  }

  @override
  Future<fpdart.Either<Failure, List<Invoice>>> getInvoices({
    required String businessId,
    String? status,
    String? customerId,
    int? page,
    int? limit,
  }) async {
    try {
      final invoices = await invoiceRemoteDataSource.getInvoices(
        businessId: businessId,
        status: status,
        customerId: customerId,
        page: page,
        limit: limit,
      );
      if (invoices == null) {
        return fpdart.left(Failure('Failed to fetch invoices'));
      }
      return fpdart.right(invoices.map((model) => model.toEntity()).toList());
    } catch (e) {
      logger.error('Error fetching invoices: $e');
      return fpdart.left(Failure('Failed to fetch invoices'));
    }
  }

  @override
  Future<fpdart.Either<Failure, List<Invoice>>> getCustomerInvoices({
    required String customerId,
    required String businessId,
    int? page,
    int? limit,
  }) async {
    try {
      final invoices = await invoiceRemoteDataSource.getCustomerInvoices(
        customerId: customerId,
        businessId: businessId,
        page: page,
        limit: limit,
      );
      if (invoices == null) {
        return fpdart.left(Failure('Failed to fetch customer invoices'));
      }
      return fpdart.right(invoices.map((model) => model.toEntity()).toList());
    } catch (e) {
      logger.error('Error fetching customer invoices: $e');
      return fpdart.left(Failure('Failed to fetch customer invoices'));
    }
  }

  @override
  Future<fpdart.Either<Failure, Invoice>> getInvoiceById({
    required String invoiceId,
    required String businessId,
  }) async {
    try {
      final invoice = await invoiceRemoteDataSource.getInvoiceById(
        invoiceId: invoiceId,
        businessId: businessId,
      );
      if (invoice == null) {
        return fpdart.left(Failure('Invoice not found'));
      }
      return fpdart.right(invoice.toEntity());
    } catch (e) {
      logger.error('Error fetching invoice: $e');
      return fpdart.left(Failure('Failed to fetch invoice'));
    }
  }

  @override
  Future<fpdart.Either<Failure, Invoice>> updateInvoicePayment({
    required String invoiceId,
    required String businessId,
    required double amountPaid,
    required String paymentMethod,
    DateTime? paymentDate,
  }) async {
    try {
      final invoice = await invoiceRemoteDataSource.updateInvoicePayment(
        invoiceId: invoiceId,
        businessId: businessId,
        amountPaid: amountPaid,
        paymentMethod: paymentMethod,
        paymentDate: paymentDate,
      );
      if (invoice == null) {
        return fpdart.left(Failure('Failed to update invoice payment'));
      }
      return fpdart.right(invoice.toEntity());
    } catch (e) {
      logger.error('Error updating invoice payment: $e');
      return fpdart.left(Failure('Failed to update invoice payment'));
    }
  }

  @override
  Future<fpdart.Either<Failure, Invoice>> updateInvoiceStatus({
    required String invoiceId,
    required String businessId,
    required String status,
  }) async {
    try {
      final invoice = await invoiceRemoteDataSource.updateInvoiceStatus(
        invoiceId: invoiceId,
        businessId: businessId,
        status: status,
      );
      if (invoice == null) {
        return fpdart.left(Failure('Failed to update invoice status'));
      }
      return fpdart.right(invoice.toEntity());
    } catch (e) {
      logger.error('Error updating invoice status: $e');
      return fpdart.left(Failure('Failed to update invoice status'));
    }
  }
}
