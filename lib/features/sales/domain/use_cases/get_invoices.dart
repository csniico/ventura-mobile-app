import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/sales/domain/entities/invoice_entity.dart';
import 'package:ventura/features/sales/domain/repositories/invoice_repository.dart';

class GetInvoices implements UseCase<List<Invoice>, GetInvoicesParams> {
  final InvoiceRepository invoiceRepository;

  GetInvoices({required this.invoiceRepository});

  @override
  Future<fpdart.Either<Failure, List<Invoice>>> call(
    GetInvoicesParams params,
  ) async {
    return await invoiceRepository.getInvoices(
      businessId: params.businessId,
      status: params.status,
      customerId: params.customerId,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetInvoicesParams {
  final String businessId;
  final String? status;
  final String? customerId;
  final int? page;
  final int? limit;

  GetInvoicesParams({
    required this.businessId,
    this.status,
    this.customerId,
    this.page,
    this.limit,
  });
}
