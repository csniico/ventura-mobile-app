import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/sales/domain/entities/invoice_entity.dart';
import 'package:ventura/features/sales/domain/repositories/invoice_repository.dart';

class CreateInvoice implements UseCase<Invoice, CreateInvoiceParams> {
  final InvoiceRepository invoiceRepository;

  CreateInvoice({required this.invoiceRepository});

  @override
  Future<fpdart.Either<Failure, Invoice>> call(
    CreateInvoiceParams params,
  ) async {
    return await invoiceRepository.createInvoice(
      businessId: params.businessId,
      customerId: params.customerId,
      orderIds: params.orderIds,
      dueDate: params.dueDate,
      notes: params.notes,
    );
  }
}

class CreateInvoiceParams {
  final String businessId;
  final String customerId;
  final List<String> orderIds;
  final DateTime? dueDate;
  final String? notes;

  CreateInvoiceParams({
    required this.businessId,
    required this.customerId,
    required this.orderIds,
    this.dueDate,
    this.notes,
  });
}
