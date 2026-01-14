import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:ventura/config/network_module.dart';
import 'package:ventura/core/data/data_sources/local/abstract_interfaces/business_local_data_source.dart';
import 'package:ventura/core/data/data_sources/local/abstract_interfaces/user_local_data_source.dart';
import 'package:ventura/core/data/data_sources/local/implementations/business_local_data_source_impl.dart';
import 'package:ventura/core/data/data_sources/local/implementations/user_local_data_source_impl.dart';
import 'package:ventura/core/data/data_sources/remote/abstract_interfaces/assets_remote_data_source.dart';
import 'package:ventura/core/data/data_sources/remote/abstract_interfaces/user_remote_data_source.dart';
import 'package:ventura/core/data/data_sources/remote/implementations/assets_remote_data_source_impl.dart';
import 'package:ventura/core/data/data_sources/remote/implementations/user_remote_data_source_impl.dart';
import 'package:ventura/core/data/repositories/assets_repository_impl.dart';
import 'package:ventura/core/data/repositories/business_repository_impl.dart';
import 'package:ventura/core/data/repositories/user_repository_impl.dart';
import 'package:ventura/core/domain/repositories/assets_repository.dart';
import 'package:ventura/core/domain/repositories/business_repository.dart';
import 'package:ventura/core/domain/repositories/user_repository.dart';
import 'package:ventura/core/domain/use_cases/asset_upload_image.dart';
import 'package:ventura/core/domain/use_cases/local_get_business.dart';
import 'package:ventura/core/domain/use_cases/local_get_user.dart';
import 'package:ventura/core/domain/use_cases/local_save_business.dart';
import 'package:ventura/core/domain/use_cases/local_save_user.dart';
import 'package:ventura/core/domain/use_cases/local_sign_out.dart';
import 'package:ventura/core/domain/use_cases/remote_get_user.dart';
import 'package:ventura/core/domain/use_cases/remote_update_user_profile.dart';
import 'package:ventura/core/presentation/cubit/app_user_cubit/app_user_cubit.dart';
import 'package:ventura/core/services/business_service.dart';
import 'package:ventura/features/appointment/data/data_sources/remote/abstract_interfaces/appointment_remote_data_source.dart';
import 'package:ventura/features/appointment/data/data_sources/remote/implementations/appointment_remote_data_source_impl.dart';
import 'package:ventura/features/appointment/data/repositories/appointment_repository_impl.dart';
import 'package:ventura/features/appointment/domain/repositories/appointment_repository.dart';
import 'package:ventura/features/appointment/domain/use_cases/create_appointment.dart';
import 'package:ventura/features/appointment/domain/use_cases/delete_appointment.dart';
import 'package:ventura/features/appointment/domain/use_cases/get_user_appointment.dart';
import 'package:ventura/features/appointment/domain/use_cases/update_appointment.dart';
import 'package:ventura/features/appointment/domain/use_cases/update_google_event_id.dart';
import 'package:ventura/features/appointment/presentation/bloc/appointment_bloc.dart';
import 'package:ventura/features/auth/data/data_sources/local/abstract_interfaces/auth_local_data_source.dart';
import 'package:ventura/features/auth/data/data_sources/local/implementations/auth_local_data_source_impl.dart';
import 'package:ventura/core/services/user_service.dart';
import 'package:ventura/features/auth/data/data_sources/remote/abstract_interfaces/auth_remote_data_source.dart';
import 'package:ventura/features/auth/data/data_sources/remote/implementations/auth_remote_datasource_impl.dart';
import 'package:ventura/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ventura/features/auth/domain/repositories/auth_repository.dart';
import 'package:ventura/features/auth/domain/use_cases/confirm_email.dart';
import 'package:ventura/features/auth/domain/use_cases/confirm_verification_code.dart';
import 'package:ventura/features/auth/domain/use_cases/create_business_profile.dart';
import 'package:ventura/features/auth/domain/use_cases/reset_password.dart';
import 'package:ventura/features/auth/domain/use_cases/user_sign_in.dart';
import 'package:ventura/features/auth/domain/use_cases/user_sign_in_with_google.dart';
import 'package:ventura/features/auth/domain/use_cases/user_sign_up.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ventura/features/auth/presentation/cubit/business_creation_cubit.dart';
import 'package:ventura/features/sales/data/data_sources/remote/abstract_interfaces/customer_remote_data_source.dart';
import 'package:ventura/features/sales/data/data_sources/remote/abstract_interfaces/invoice_remote_data_source.dart';
import 'package:ventura/features/sales/data/data_sources/remote/abstract_interfaces/order_remote_data_source.dart';
import 'package:ventura/features/sales/data/data_sources/remote/abstract_interfaces/product_remote_data_source.dart';
import 'package:ventura/features/sales/data/data_sources/remote/abstract_interfaces/service_remote_data_source.dart';
import 'package:ventura/features/sales/data/data_sources/remote/implementations/customer_remote_data_source_impl.dart';
import 'package:ventura/features/sales/data/data_sources/remote/implementations/invoice_remote_data_source_impl.dart';
import 'package:ventura/features/sales/data/data_sources/remote/implementations/order_remote_data_source_impl.dart';
import 'package:ventura/features/sales/data/data_sources/remote/implementations/product_remote_data_source_impl.dart';
import 'package:ventura/features/sales/data/data_sources/remote/implementations/service_remote_data_source_impl.dart';
import 'package:ventura/features/sales/data/repositories/customer_repository_impl.dart';
import 'package:ventura/features/sales/data/repositories/invoice_repository_impl.dart';
import 'package:ventura/features/sales/data/repositories/order_repository_impl.dart';
import 'package:ventura/features/sales/data/repositories/product_repository_impl.dart';
import 'package:ventura/features/sales/data/repositories/service_repository_impl.dart';
import 'package:ventura/features/sales/domain/repositories/customer_repository.dart';
import 'package:ventura/features/sales/domain/repositories/invoice_repository.dart';
import 'package:ventura/features/sales/domain/repositories/order_repository.dart';
import 'package:ventura/features/sales/domain/repositories/product_repository.dart';
import 'package:ventura/features/sales/domain/repositories/service_repository.dart';
import 'package:ventura/features/sales/domain/use_cases/create_customer.dart';
import 'package:ventura/features/sales/domain/use_cases/create_invoice.dart';
import 'package:ventura/features/sales/domain/use_cases/create_order.dart';
import 'package:ventura/features/sales/domain/use_cases/create_product.dart';
import 'package:ventura/features/sales/domain/use_cases/create_service.dart';
import 'package:ventura/features/sales/domain/use_cases/delete_customer.dart';
import 'package:ventura/features/sales/domain/use_cases/delete_product.dart';
import 'package:ventura/features/sales/domain/use_cases/delete_service.dart';
import 'package:ventura/features/sales/domain/use_cases/get_customer_by_id.dart';
import 'package:ventura/features/sales/domain/use_cases/get_customer_invoices.dart';
import 'package:ventura/features/sales/domain/use_cases/get_customer_orders.dart';
import 'package:ventura/features/sales/domain/use_cases/get_customers.dart';
import 'package:ventura/features/sales/domain/use_cases/get_invoice_by_id.dart';
import 'package:ventura/features/sales/domain/use_cases/get_invoices.dart';
import 'package:ventura/features/sales/domain/use_cases/get_order_by_id.dart';
import 'package:ventura/features/sales/domain/use_cases/get_order_stats.dart';
import 'package:ventura/features/sales/domain/use_cases/get_orders.dart';
import 'package:ventura/features/sales/domain/use_cases/get_product_by_id.dart';
import 'package:ventura/features/sales/domain/use_cases/get_service_by_id.dart';
import 'package:ventura/features/sales/domain/use_cases/search_orders.dart';
import 'package:ventura/features/sales/domain/use_cases/search_resources.dart';
import 'package:ventura/features/sales/domain/use_cases/update_customer.dart';
import 'package:ventura/features/sales/domain/use_cases/update_invoice_payment.dart';
import 'package:ventura/features/sales/domain/use_cases/update_invoice_status.dart';
import 'package:ventura/features/sales/domain/use_cases/update_order_status.dart';
import 'package:ventura/features/sales/domain/use_cases/update_product.dart';
import 'package:ventura/features/sales/domain/use_cases/update_service.dart';
import 'package:ventura/features/sales/presentation/bloc/customer_bloc.dart';
import 'package:ventura/features/sales/presentation/bloc/invoice_bloc.dart';
import 'package:ventura/features/sales/presentation/bloc/order_bloc.dart';
import 'package:ventura/features/sales/presentation/bloc/product_bloc.dart';
import 'package:ventura/features/sales/presentation/bloc/service_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // register global Dio instance from NetworkModule
  serviceLocator.registerLazySingleton<Dio>(() => NetworkModule.instance.dio);
  _initAuthDependencies();
  _initAppointmentDependencies();
  _initSalesDependencies();
  serviceLocator.registerLazySingleton(() => UserService());
  serviceLocator.registerLazySingleton(() => BusinessService());
}

void _initAuthDependencies() {
  // DATA SOURCES
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDatasourceImpl(dio: serviceLocator()),
    )
    ..registerFactory<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(userService: serviceLocator()),
    )
    ..registerFactory<UserLocalDataSource>(
      () => UserLocalDataSourceImpl(userService: serviceLocator()),
    )
    ..registerFactory<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(dio: serviceLocator()),
    )
    ..registerFactory<BusinessLocalDataSource>(
      () => BusinessLocalDataSourceImpl(businessService: serviceLocator()),
    )
    ..registerFactory<AssetsRemoteDataSource>(
      () => AssetsRemoteDataSourceImpl(dio: serviceLocator()),
    )
    // REPOSITORIES
    ..registerFactory<UserRepository>(
      () => UserRepositoryImpl(
        userLocalDataSource: serviceLocator(),
        userRemoteDataSource: serviceLocator(),
      ),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        authRemoteDataSource: serviceLocator(),
        userRemoteDataSource: serviceLocator(),
      ),
    )
    ..registerFactory<BusinessRepository>(
      () => BusinessRepositoryImpl(businessLocalDataSource: serviceLocator()),
    )
    ..registerFactory<AssetsRepository>(
      () => AssetsRepositoryImpl(assetsRemoteDataSource: serviceLocator()),
    )
    // USE CASES
    ..registerFactory(() => RemoteGetUser(userRepository: serviceLocator()))
    ..registerFactory(() => UserSignIn(authRepository: serviceLocator()))
    ..registerFactory(() => LocalGetUser(userRepository: serviceLocator()))
    ..registerFactory(() => LocalSaveUser(userRepository: serviceLocator()))
    ..registerFactory(() => LocalSignOut(userRepository: serviceLocator()))
    ..registerFactory(
      () => LocalGetBusiness(businessRepository: serviceLocator()),
    )
    ..registerFactory(
      () => LocalSaveBusiness(businessRepository: serviceLocator()),
    )
    ..registerFactory(
      () => UserSignInWithGoogle(authRepository: serviceLocator()),
    )
    ..registerFactory(() => ConfirmEmail(authRepository: serviceLocator()))
    ..registerFactory(
      () => ConfirmVerificationCode(authRepository: serviceLocator()),
    )
    ..registerFactory(() => UserSignUp(authRepository: serviceLocator()))
    ..registerFactory(() => ResetPassword(authRepository: serviceLocator()))
    ..registerFactory(
      () => AssetUploadImage(assetsRepository: serviceLocator()),
    )
    ..registerFactory(
      () => CreateBusinessProfile(authRepository: serviceLocator()),
    )
    ..registerFactory(
      () => RemoteUpdateUserProfile(userRepository: serviceLocator()),
    )
    // BLOC
    ..registerFactory(() => AppUserCubit())
    ..registerFactory(
      () => BusinessCreationCubit(
        localSaveBusiness: serviceLocator(),
        localSaveUser: serviceLocator(),
        assetUploadImage: serviceLocator(),
        createBusinessProfile: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => AuthBloc(
        userSignIn: serviceLocator(),
        userSignUp: serviceLocator(),
        localGetUser: serviceLocator(),
        localSaveUser: serviceLocator(),
        localSignOut: serviceLocator(),
        confirmEmail: serviceLocator(),
        userSignInWithGoogle: serviceLocator(),
        confirmVerificationCode: serviceLocator(),
        resetPassword: serviceLocator(),
        appUserCubit: serviceLocator(),
        remoteGetUser: serviceLocator(),
        assetUploadImage: serviceLocator(),
        remoteUpdateUserProfile: serviceLocator(),
      ),
    );
}

void _initAppointmentDependencies() {
  serviceLocator
    // DATA SOURCES
    ..registerFactory<AppointmentRemoteDataSource>(
      () => AppointmentRemoteDataSourceImpl(dio: serviceLocator()),
    )
    //    REPOSITORIES
    ..registerFactory<AppointmentRepository>(
      () => AppointmentRepositoryImpl(
        appointmentRemoteDataSource: serviceLocator(),
      ),
    )
    //     USE-CASES
    ..registerFactory(
      () => CreateAppointment(appointmentRepository: serviceLocator()),
    )
    ..registerFactory(
      () => UpdateAppointment(appointmentRepository: serviceLocator()),
    )
    ..registerFactory(
      () => UpdateGoogleEventId(appointmentRepository: serviceLocator()),
    )
    ..registerFactory(
      () => DeleteAppointment(appointmentRepository: serviceLocator()),
    )
    ..registerFactory(
      () => GetUserAppointment(appointmentRepository: serviceLocator()),
    )
    //     BLOC
    ..registerLazySingleton(
      () => AppointmentBloc(
        createAppointment: serviceLocator(),
        updateAppointment: serviceLocator(),
        updateGoogleEventId: serviceLocator(),
        getUserAppointment: serviceLocator(),
        deleteAppointment: serviceLocator(),
      ),
    );
}

void _initSalesDependencies() {
  serviceLocator
    // DATA SOURCES
    ..registerFactory<CustomerRemoteDataSource>(
      () => CustomerRemoteDataSourceImpl(dio: serviceLocator()),
    )
    ..registerFactory<InvoiceRemoteDataSource>(
      () => InvoiceRemoteDataSourceImpl(dio: serviceLocator()),
    )
    ..registerFactory<OrderRemoteDataSource>(
      () => OrderRemoteDataSourceImpl(dio: serviceLocator()),
    )
    ..registerFactory<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(dio: serviceLocator()),
    )
    ..registerFactory<ServiceRemoteDataSource>(
      () => ServiceRemoteDataSourceImpl(dio: serviceLocator()),
    )
    // REPOSITORIES
    ..registerFactory<CustomerRepository>(
      () => CustomerRepositoryImpl(customerRemoteDataSource: serviceLocator()),
    )
    ..registerFactory<InvoiceRepository>(
      () => InvoiceRepositoryImpl(invoiceRemoteDataSource: serviceLocator()),
    )
    ..registerFactory<OrderRepository>(
      () => OrderRepositoryImpl(orderRemoteDataSource: serviceLocator()),
    )
    ..registerFactory<ProductRepository>(
      () => ProductRepositoryImpl(productRemoteDataSource: serviceLocator()),
    )
    ..registerFactory<ServiceRepository>(
      () => ServiceRepositoryImpl(serviceRemoteDataSource: serviceLocator()),
    )
    // USE CASES - Customer
    ..registerFactory(() => GetCustomers(customerRepository: serviceLocator()))
    ..registerFactory(
      () => GetCustomerById(customerRepository: serviceLocator()),
    )
    ..registerFactory(
      () => CreateCustomer(customerRepository: serviceLocator()),
    )
    ..registerFactory(
      () => UpdateCustomer(customerRepository: serviceLocator()),
    )
    ..registerFactory(
      () => DeleteCustomer(customerRepository: serviceLocator()),
    )
    // USE CASES - Invoice
    ..registerFactory(() => CreateInvoice(invoiceRepository: serviceLocator()))
    ..registerFactory(() => GetInvoices(invoiceRepository: serviceLocator()))
    ..registerFactory(
      () => GetCustomerInvoices(invoiceRepository: serviceLocator()),
    )
    ..registerFactory(() => GetInvoiceById(invoiceRepository: serviceLocator()))
    ..registerFactory(
      () => UpdateInvoicePayment(invoiceRepository: serviceLocator()),
    )
    ..registerFactory(
      () => UpdateInvoiceStatus(invoiceRepository: serviceLocator()),
    )
    // USE CASES - Order
    ..registerFactory(() => CreateOrder(orderRepository: serviceLocator()))
    ..registerFactory(() => GetOrders(orderRepository: serviceLocator()))
    ..registerFactory(() => SearchOrders(orderRepository: serviceLocator()))
    ..registerFactory(() => GetOrderStats(orderRepository: serviceLocator()))
    ..registerFactory(
      () => GetCustomerOrders(orderRepository: serviceLocator()),
    )
    ..registerFactory(() => GetOrderById(orderRepository: serviceLocator()))
    ..registerFactory(
      () => UpdateOrderStatus(orderRepository: serviceLocator()),
    )
    // USE CASES - Product
    ..registerFactory(
      () => SearchResources(productRepository: serviceLocator()),
    )
    ..registerFactory(() => GetProductById(productRepository: serviceLocator()))
    ..registerFactory(() => CreateProduct(productRepository: serviceLocator()))
    ..registerFactory(() => UpdateProduct(productRepository: serviceLocator()))
    ..registerFactory(() => DeleteProduct(productRepository: serviceLocator()))
    // USE CASES - Service
    ..registerFactory(() => GetServiceById(serviceRepository: serviceLocator()))
    ..registerFactory(() => CreateService(serviceRepository: serviceLocator()))
    ..registerFactory(() => UpdateService(serviceRepository: serviceLocator()))
    ..registerFactory(() => DeleteService(serviceRepository: serviceLocator()))
    // BLOCS
    ..registerFactory(
      () => CustomerBloc(
        getCustomers: serviceLocator(),
        getCustomerById: serviceLocator(),
        createCustomer: serviceLocator(),
        updateCustomer: serviceLocator(),
        deleteCustomer: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => InvoiceBloc(
        createInvoice: serviceLocator(),
        getInvoices: serviceLocator(),
        getCustomerInvoices: serviceLocator(),
        getInvoiceById: serviceLocator(),
        updateInvoicePayment: serviceLocator(),
        updateInvoiceStatus: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => OrderBloc(
        createOrder: serviceLocator(),
        getOrders: serviceLocator(),
        searchOrders: serviceLocator(),
        getOrderStats: serviceLocator(),
        getCustomerOrders: serviceLocator(),
        getOrderById: serviceLocator(),
        updateOrderStatus: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => ProductBloc(
        searchResources: serviceLocator(),
        getProductById: serviceLocator(),
        createProduct: serviceLocator(),
        updateProduct: serviceLocator(),
        deleteProduct: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => ServiceBloc(
        getServiceById: serviceLocator(),
        createService: serviceLocator(),
        updateService: serviceLocator(),
        deleteService: serviceLocator(),
      ),
    );
}
