import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/sales/domain/entities/invoice_entity.dart';
import 'package:ventura/features/sales/domain/repositories/invoice_repository.dart';

class GetInvoiceById implements UseCase<Invoice, GetInvoiceByIdParams> {
  final InvoiceRepository invoiceRepository;

  GetInvoiceById({required this.invoiceRepository});

  @override
  Future<fpdart.Either<Failure, Invoice>> call(
    GetInvoiceByIdParams params,
  ) async {
    return await invoiceRepository.getInvoiceById(
      invoiceId: params.invoiceId,
      businessId: params.businessId,
    );
  }
}

class GetInvoiceByIdParams {
  final String invoiceId;
  final String businessId;

  GetInvoiceByIdParams({required this.invoiceId, required this.businessId});
}
