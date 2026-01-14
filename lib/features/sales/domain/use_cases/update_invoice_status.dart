import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/sales/domain/entities/invoice_entity.dart';
import 'package:ventura/features/sales/domain/repositories/invoice_repository.dart';

class UpdateInvoiceStatus
    implements UseCase<Invoice, UpdateInvoiceStatusParams> {
  final InvoiceRepository invoiceRepository;

  UpdateInvoiceStatus({required this.invoiceRepository});

  @override
  Future<fpdart.Either<Failure, Invoice>> call(
    UpdateInvoiceStatusParams params,
  ) async {
    return await invoiceRepository.updateInvoiceStatus(
      invoiceId: params.invoiceId,
      businessId: params.businessId,
      status: params.status,
    );
  }
}

class UpdateInvoiceStatusParams {
  final String invoiceId;
  final String businessId;
  final String status;

  UpdateInvoiceStatusParams({
    required this.invoiceId,
    required this.businessId,
    required this.status,
  });
}
