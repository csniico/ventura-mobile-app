import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/sales/domain/entities/invoice_entity.dart';
import 'package:ventura/features/sales/domain/repositories/invoice_repository.dart';

class UpdateInvoicePayment
    implements UseCase<Invoice, UpdateInvoicePaymentParams> {
  final InvoiceRepository invoiceRepository;

  UpdateInvoicePayment({required this.invoiceRepository});

  @override
  Future<fpdart.Either<Failure, Invoice>> call(
    UpdateInvoicePaymentParams params,
  ) async {
    return await invoiceRepository.updateInvoicePayment(
      invoiceId: params.invoiceId,
      businessId: params.businessId,
      amountPaid: params.amountPaid,
      paymentMethod: params.paymentMethod,
      paymentDate: params.paymentDate,
    );
  }
}

class UpdateInvoicePaymentParams {
  final String invoiceId;
  final String businessId;
  final double amountPaid;
  final String paymentMethod;
  final DateTime? paymentDate;

  UpdateInvoicePaymentParams({
    required this.invoiceId,
    required this.businessId,
    required this.amountPaid,
    required this.paymentMethod,
    this.paymentDate,
  });
}
