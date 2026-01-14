import 'package:flutter_dotenv/flutter_dotenv.dart';

class ServerRoutes {
  ServerRoutes._internal();

  static final ServerRoutes instance = ServerRoutes._internal();

  late final String? serverUrl = dotenv.env['SERVER_URL'];
  final String signInWithEmailPassword = '/auth/signin';
  final String signInWithGoogle = '/auth/google/login/mobile';
  final String signUp = '/auth/signup';
  final String confirmEmail = '/auth/confirm-email';
  final String confirmVerificationCode = '/auth/verify-code';
  final String resetPassword = '/auth/reset-password';
  final String uploadImageAsset = '/assets/images';
  final String createBusiness = '/businesses';
  final String createAppointment = '/appointments';
  final String getUserAppointments = '/appointments/user';
  final String getBusinessAppointments = '/appointments/business';

  String deleteAppointment(String appointmentId) =>
      '/appointments/$appointmentId';

  String updateGoogleCalendarEvent(String appointmentId) =>
      '/appointments/google-event/$appointmentId';

  String updateAppointment(String appointmentId) =>
      '/appointments/$appointmentId';

  String getUserById(String userId) => '/users/$userId';
  String updateUserProfile(String userId) => '/users/profile/$userId';

  // Customer routes
  final String getCustomers = '/customers';
  final String createCustomer = '/customers';
  String updateCustomer(String customerId) => '/customers/$customerId';
  String deleteCustomer(String customerId) => '/customers/$customerId';

  // Resource routes (Products & Services)
  final String searchResources = '/resources/search';
  final String getResources = '/resources';
  final String createProduct = '/resources/product';
  final String createService = '/resources/service';
  String updateProduct(String productId) => '/resources/product/$productId';
  String updateService(String serviceId) => '/resources/service/$serviceId';
  String deleteProduct(String productId) => '/resources/product/$productId';
  String deleteService(String serviceId) => '/resources/service/$serviceId';

  // Order routes
  final String getOrders = '/orders';
  final String createOrder = '/orders';
  final String searchOrders = '/orders/search';
  final String getOrderStats = '/orders/stats';
  String getOrderById(String orderId) => '/orders/$orderId';
  String getCustomerOrders(String customerId) => '/orders/customer/$customerId';
  String updateOrderStatus(String orderId) => '/orders/$orderId/status';

  // Invoice routes
  final String getInvoices = '/invoices';
  final String createInvoice = '/invoices';
  String getInvoiceById(String invoiceId) => '/invoices/$invoiceId';
  String getCustomerInvoices(String customerId) =>
      '/invoices/customer/$customerId';
  String updateInvoicePayment(String invoiceId) =>
      '/invoices/$invoiceId/payment';
  String updateInvoiceStatus(String invoiceId) => '/invoices/$invoiceId/status';
}
