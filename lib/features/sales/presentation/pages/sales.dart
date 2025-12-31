import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/features/sales/presentation/pages/list_customers.dart';
import 'package:ventura/features/sales/presentation/pages/list_invoices.dart';
import 'package:ventura/features/sales/presentation/pages/list_orders.dart';
import 'package:ventura/features/sales/presentation/pages/list_products.dart';
import 'package:ventura/features/sales/presentation/widgets/sales_page_tab_bar.dart';

class Sales extends StatelessWidget {
  const Sales({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: DefaultTabController(
        length: 4,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SalesPageTabBar(),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 70.0),
              child: TabBarView(
                children: [
                  ListInvoices(),

                  ListOrders(),

                  ListProducts(),

                  ListCustomers(),
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
            child: HugeIcon(icon: HugeIcons.strokeRoundedInvoice01),
            label: 'New Invoice',
            onTap: () {},
          ),
          SpeedDialChild(
            child: HugeIcon(icon: HugeIcons.strokeRoundedShoppingCart01),
            label: 'New Order',
            onTap: () {},
          ),
          SpeedDialChild(
            child: HugeIcon(icon: HugeIcons.strokeRoundedShoppingBag01),
            label: 'New Product',
            onTap: () {},
          ),
          SpeedDialChild(
            child: HugeIcon(icon: HugeIcons.strokeRoundedUser),
            label: 'New Customer',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
