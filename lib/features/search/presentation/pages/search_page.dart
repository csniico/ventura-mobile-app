import 'package:flutter/material.dart';
import 'package:ventura/core/presentation/widgets/ventura_app_bar/ventura_app_bar.dart';
import 'package:ventura/core/presentation/widgets/ventura_app_bar/app_bar_type.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VenturaAppBar(
        type: AppBarType.secondary,
        title: 'Search',
        centerTitle: true,
      ),
      body: SafeArea(child: Center(child: Text('Search Page'))),
    );
  }
}
