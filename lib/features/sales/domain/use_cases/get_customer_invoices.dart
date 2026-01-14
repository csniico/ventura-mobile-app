import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/sales/domain/entities/invoice_entity.dart';
import 'package:ventura/features/sales/domain/repositories/invoice_repository.dart';

class GetCustomerInvoices
    implements UseCase<List<Invoice>, GetCustomerInvoicesParams> {
  final InvoiceRepository invoiceRepository;

  GetCustomerInvoices({required this.invoiceRepository});

  @override
  Future<fpdart.Either<Failure, List<Invoice>>> call(
    GetCustomerInvoicesParams params,
  ) async {
    return await invoiceRepository.getCustomerInvoices(
      customerId: params.customerId,
      businessId: params.businessId,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetCustomerInvoicesParams {
  final String customerId;
  final String businessId;
  final int? page;
  final int? limit;

  GetCustomerInvoicesParams({
    required this.customerId,
    required this.businessId,
    this.page,
    this.limit,
  });
}
