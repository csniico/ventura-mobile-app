import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/services/user_service.dart';
import 'package:ventura/features/sales/presentation/bloc/customer_bloc.dart';
import 'package:ventura/features/sales/presentation/bloc/invoice_bloc.dart';
import 'package:ventura/features/sales/presentation/bloc/order_bloc.dart';
import 'package:ventura/features/sales/presentation/bloc/product_bloc.dart';
import 'package:ventura/features/sales/presentation/pages/create_customers.dart';
import 'package:ventura/features/sales/presentation/pages/create_invoice.dart';
import 'package:ventura/features/sales/presentation/pages/create_order.dart';
import 'package:ventura/features/sales/presentation/pages/create_products.dart';
import 'package:ventura/features/sales/presentation/pages/list_customers.dart';
import 'package:ventura/features/sales/presentation/pages/list_invoices.dart';
import 'package:ventura/features/sales/presentation/pages/list_orders.dart';
import 'package:ventura/features/sales/presentation/pages/list_products.dart';
import 'package:ventura/features/sales/presentation/widgets/sales_page_tab_bar.dart';
import 'package:ventura/init_dependencies.dart';

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  late final String _businessId;
  late final InvoiceBloc _invoiceBloc;
  late final OrderBloc _orderBloc;
  late final ProductBloc _productBloc;
  late final CustomerBloc _customerBloc;

  @override
  void initState() {
    super.initState();
    // Use cached businessId synchronously - user must be logged in to reach this page
    _businessId = UserService().businessId!;

    // Initialize blocs immediately
    _invoiceBloc = serviceLocator<InvoiceBloc>()
      ..add(InvoiceGetListEvent(businessId: _businessId));
    _orderBloc = serviceLocator<OrderBloc>()
      ..add(OrderGetListEvent(businessId: _businessId));
    _productBloc = serviceLocator<ProductBloc>()
      ..add(ProductSearchEvent(businessId: _businessId, searchQuery: ''));
    _customerBloc = serviceLocator<CustomerBloc>()
      ..add(CustomerGetEvent(businessId: _businessId));
  }

  Future<void> _refreshInvoices() async {
    _invoiceBloc.add(InvoiceGetListEvent(businessId: _businessId));
  }

  Future<void> _refreshOrders() async {
    _orderBloc.add(OrderGetListEvent(businessId: _businessId));
  }

  Future<void> _refreshProducts() async {
    _productBloc.add(
      ProductSearchEvent(businessId: _businessId, searchQuery: ''),
    );
  }

  Future<void> _refreshCustomers() async {
    _customerBloc.add(CustomerGetEvent(businessId: _businessId));
  }

  @override
  void dispose() {
    _invoiceBloc.close();
    _orderBloc.close();
    _productBloc.close();
    _customerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InvoiceBloc>.value(value: _invoiceBloc),
        BlocProvider<OrderBloc>.value(value: _orderBloc),
        BlocProvider<ProductBloc>.value(value: _productBloc),
        BlocProvider<CustomerBloc>.value(value: _customerBloc),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: DefaultTabController(
          length: 4,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SalesPageTabBar(),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    RefreshIndicator(
                      onRefresh: _refreshInvoices,
                      child: ListInvoices(),
                    ),
                    RefreshIndicator(
                      onRefresh: _refreshOrders,
                      child: ListOrders(),
                    ),
                    RefreshIndicator(
                      onRefresh: _refreshProducts,
                      child: ListProducts(),
                    ),
                    RefreshIndicator(
                      onRefresh: _refreshCustomers,
                      child: ListCustomers(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            SpeedDialChild(
              child: HugeIcon(icon: HugeIcons.strokeRoundedDocumentValidation),
              label: 'Invoice',
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CreateInvoice(),
                  ),
                );
                if (context.mounted) {
                  _refreshInvoices();
                }
              },
            ),
            SpeedDialChild(
              child: HugeIcon(icon: HugeIcons.strokeRoundedPackage),
              label: 'Order',
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const CreateOrder()),
                );
                if (context.mounted) {
                  _refreshOrders();
                }
              },
            ),
            SpeedDialChild(
              child: HugeIcon(icon: HugeIcons.strokeRoundedShoppingBag01),
              label: 'Product',
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CreateProducts(),
                  ),
                );
                if (context.mounted) {
                  _refreshProducts();
                }
              },
            ),
            SpeedDialChild(
              child: HugeIcon(icon: HugeIcons.strokeRoundedUser),
              label: 'Customer',
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CreateCustomers(),
                  ),
                );
                if (context.mounted) {
                  _refreshCustomers();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
