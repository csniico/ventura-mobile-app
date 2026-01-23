import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class _SalesState extends State<Sales> with TickerProviderStateMixin {
  late final String _businessId;
  late final InvoiceBloc _invoiceBloc;
  late final OrderBloc _orderBloc;
  late final ProductBloc _productBloc;
  late final CustomerBloc _customerBloc;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Use cached businessId synchronously - user must be logged in to reach this page
    _businessId = UserService().businessId!;

    // Initialize tab controller
    _tabController = TabController(length: 4, vsync: this);

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

  void _onFabPressed() {
    final currentIndex = _tabController.index;

    switch (currentIndex) {
      case 0:
        Navigator.of(context)
            .push(
              MaterialPageRoute(builder: (context) => const CreateInvoice()),
            )
            .then((_) => _refreshInvoices());
        break;
      case 1:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const CreateOrder()))
            .then((_) => _refreshOrders());
        break;
      case 2:
        Navigator.of(context)
            .push(
              MaterialPageRoute(builder: (context) => const CreateProducts()),
            )
            .then((_) => _refreshProducts());
        break;
      case 3:
        Navigator.of(context)
            .push(
              MaterialPageRoute(builder: (context) => const CreateCustomers()),
            )
            .then((_) => _refreshCustomers());
        break;
    }
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
    _tabController.dispose();
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SalesPageTabBar(controller: _tabController),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
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
        floatingActionButton: FloatingActionButton(
          onPressed: _onFabPressed,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
