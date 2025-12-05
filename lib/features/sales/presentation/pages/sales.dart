import 'package:flutter/material.dart';
import 'package:ventura/features/sales/presentation/widgets/sales_page_tab_bar.dart';

class Sales extends StatelessWidget {
  const Sales({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          SalesPageTabBar(),
          Expanded(
            child: TabBarView(
              children: [
                Center(child: Text("123"),),
                Center(child: Text("123"),),
                Center(child: Text("123"),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
