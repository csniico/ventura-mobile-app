import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/features/sales/domain/entities/customer_entity.dart';
import 'package:ventura/features/sales/presentation/bloc/customer_bloc.dart';
import 'package:ventura/features/sales/presentation/pages/edit_customer.dart';
import 'package:ventura/init_dependencies.dart';

class ViewCustomer extends StatefulWidget {
  const ViewCustomer({super.key, required this.customer});
  final Customer customer;

  @override
  State<ViewCustomer> createState() => _ViewCustomerState();
}

class _ViewCustomerState extends State<ViewCustomer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<CustomerBloc>(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(8.0),
            child: const SizedBox(height: 8.0),
          ),
          title: Text(
            widget.customer.name,
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          leading: IconButton(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedArrowLeft01,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 30,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedPencilEdit02,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 26,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        EditCustomer(customer: widget.customer),
                  ),
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_contactInfoSection(), _notesSection()],
            ),
          ),
        ),
      ),
    );
  }

  Widget _contactInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 12.0, top: 8.0),
          child: Text(
            'Contact Information',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Card(
          elevation: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: HugeIcon(
                  icon: HugeIcons.strokeRoundedMail01,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 24,
                ),
                title: Text(widget.customer.email ?? 'No email provided'),
              ),
              ListTile(
                leading: HugeIcon(
                  icon: HugeIcons.strokeRoundedCall,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 24,
                ),
                title: Text(
                  widget.customer.phone ?? 'No phone number provided',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _notesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 12.0, top: 16.0),
          child: Text('Notes', style: Theme.of(context).textTheme.titleMedium),
        ),
        Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              widget.customer.notes ?? 'No notes available for this customer.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
