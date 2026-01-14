import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/services/user_service.dart';
import 'package:ventura/features/sales/presentation/bloc/invoice_bloc.dart';
import 'package:ventura/features/sales/presentation/pages/create_invoice.dart';
import 'package:ventura/features/sales/presentation/pages/edit_invoice.dart';
import 'package:ventura/features/sales/presentation/pages/view_invoice.dart';
import 'package:ventura/init_dependencies.dart';

class ListInvoices extends StatefulWidget {
  const ListInvoices({super.key});

  @override
  State<ListInvoices> createState() => _ListInvoicesState();
}

class _ListInvoicesState extends State<ListInvoices> {
  late String _businessId;

  @override
  void initState() {
    super.initState();
    _businessId = '';
    _loadBusinessId();
  }

  Future<void> _loadBusinessId() async {
    final user = await UserService().getUser();
    if (user != null) {
      setState(() {
        _businessId = user.businessId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          serviceLocator<InvoiceBloc>()
            ..add(InvoiceGetListEvent(businessId: _businessId)),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Invoices'),
          actions: [
            IconButton(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedFile01,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CreateInvoice(),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<InvoiceBloc, InvoiceState>(
          builder: (context, state) {
            if (state is InvoiceLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is InvoiceListLoadedState) {
              final invoices = state.invoices;
              if (invoices.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedFile01,
                        color: Theme.of(context).disabledColor,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No invoices found',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: Theme.of(context).disabledColor),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Create your first invoice to get started',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: invoices.length,
                itemBuilder: (context, index) {
                  final invoice = invoices[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                ViewInvoice(invoiceId: invoice.id),
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedFile01,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      title: Text('Invoice #${invoice.invoiceNumber}'),
                      subtitle: Text(
                        '\$${invoice.totalAmount.toStringAsFixed(2)} • ${invoice.status.name}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: HugeIcon(
                              icon: HugeIcons.strokeRoundedPencilEdit02,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditInvoice(invoiceId: invoice.id),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is InvoiceErrorState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedFile01,
                      color: Theme.of(context).colorScheme.error,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading invoices',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).disabledColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<InvoiceBloc>().add(
                          InvoiceGetListEvent(businessId: _businessId),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
