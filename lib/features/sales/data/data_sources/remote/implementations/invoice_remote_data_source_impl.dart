import 'package:dio/dio.dart';
import 'package:ventura/config/app_logger.dart';
import 'package:ventura/config/server_routes.dart';
import 'package:ventura/features/sales/data/data_sources/remote/abstract_interfaces/invoice_remote_data_source.dart';
import 'package:ventura/features/sales/data/models/invoice_model.dart';

class InvoiceRemoteDataSourceImpl implements InvoiceRemoteDataSource {
  final Dio dio;
  final routes = ServerRoutes.instance;
  final logger = AppLogger('InvoiceRemoteDataSourceImpl');

  InvoiceRemoteDataSourceImpl({required this.dio});

  @override
  Future<InvoiceModel?> createInvoice({
    required String businessId,
    required String customerId,
    required List<String> orderIds,
    DateTime? dueDate,
    String? notes,
  }) async {
    try {
      final response = await dio.post(
        '${routes.serverUrl}${routes.createInvoice}',
        data: {
          'businessId': businessId,
          'customerId': customerId,
          'orderIds': orderIds,
          if (dueDate != null) 'dueDate': dueDate.toIso8601String(),
          if (notes != null) 'notes': notes,
        },
      );

      logger.info('Full response: ${response.data}');
      logger.info('Response type: ${response.data.runtimeType}');
      logger.info('Status code: ${response.statusCode}');

      // Check if response.data is null
      if (response.data == null) {
        logger.error('Response data is null');
        return null;
      }

      // Check if the response has a 'data' field
      if (response.data is Map && response.data['data'] != null) {
        return InvoiceModel.fromJson(response.data['data']);
      }

      // If response.data is directly the invoice object (no 'data' wrapper)
      if (response.data is Map) {
        return InvoiceModel.fromJson(response.data);
      }

      logger.error('Unexpected response structure');
      return null;
    } on DioException catch (e) {
      logger.error('DioException: ${e.message}');
      logger.error('Response status: ${e.response?.statusCode}');
      logger.error('Response data: ${e.response?.data}');
      return null;
    } catch (e) {
      logger.error('Unexpected error: $e');
      return null;
    }
  }

  @override
  Future<List<InvoiceModel>?> getInvoices({
    required String businessId,
    String? status,
    String? customerId,
    int? page,
    int? limit,
  }) async {
    try {
      final response = await dio.get(
        '${routes.serverUrl}${routes.getInvoices}',
        queryParameters: {
          'businessId': businessId,
          if (status != null) 'status': status,
          if (customerId != null) 'customerId': customerId,
          'page': page ?? 1,
          'limit': limit ?? 10,
        },
      );
      logger.info(response.data.toString());
      return List<InvoiceModel>.from(
        response.data['data'].map((e) => InvoiceModel.fromJson(e)),
      );
    } on DioException catch (e) {
      logger.error(e.response.toString());
      return null;
    }
  }

  @override
  Future<List<InvoiceModel>?> getCustomerInvoices({
    required String customerId,
    required String businessId,
    int? page,
    int? limit,
  }) async {
    try {
      final response = await dio.get(
        '${routes.serverUrl}${routes.getCustomerInvoices(customerId)}',
        queryParameters: {
          'businessId': businessId,
          'page': page ?? 1,
          'limit': limit ?? 10,
        },
      );
      logger.info(response.data.toString());
      return List<InvoiceModel>.from(
        response.data['data'].map((e) => InvoiceModel.fromJson(e)),
      );
    } on DioException catch (e) {
      logger.error(e.response.toString());
      return null;
    }
  }

  @override
  Future<InvoiceModel?> getInvoiceById({
    required String invoiceId,
    required String businessId,
  }) async {
    try {
      final response = await dio.get(
        '${routes.serverUrl}${routes.getInvoiceById(invoiceId)}',
        queryParameters: {'businessId': businessId},
      );
      logger.info(response.data.toString());
      return InvoiceModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      logger.error(e.response.toString());
      return null;
    }
  }

  @override
  Future<InvoiceModel?> updateInvoicePayment({
    required String invoiceId,
    required String businessId,
    required double amountPaid,
    required String paymentMethod,
    DateTime? paymentDate,
  }) async {
    try {
      final response = await dio.patch(
        '${routes.serverUrl}${routes.updateInvoicePayment(invoiceId)}',
        queryParameters: {'businessId': businessId},
        data: {
          'amountPaid': amountPaid,
          'paymentMethod': paymentMethod,
          if (paymentDate != null) 'paymentDate': paymentDate.toIso8601String(),
        },
      );
      logger.info(response.data.toString());
      return InvoiceModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      logger.error(e.response.toString());
      return null;
    }
  }

  @override
  Future<InvoiceModel?> updateInvoiceStatus({
    required String invoiceId,
    required String businessId,
    required String status,
  }) async {
    try {
      final response = await dio.patch(
        '${routes.serverUrl}${routes.updateInvoiceStatus(invoiceId)}',
        queryParameters: {'businessId': businessId},
        data: {'status': status},
      );
      logger.info(response.data.toString());
      return InvoiceModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      logger.error(e.response.toString());
      return null;
    }
  }
}
