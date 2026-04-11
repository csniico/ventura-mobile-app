import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:ventura/features/sales/domain/entities/invoice_status.dart';
import 'package:ventura/features/sales/presentation/bloc/invoice_bloc.dart';
import 'package:ventura/features/sales/presentation/pages/view_invoice.dart';

class ListInvoices extends StatefulWidget {
  const ListInvoices({super.key});

  @override
  State<ListInvoices> createState() => _ListInvoicesState();
}

class _ListInvoicesState extends State<ListInvoices> {
  final TextEditingController _searchController = TextEditingController();
  Set<InvoiceStatus> _selectedStatuses = {};
  double _minAmount = 0;
  double _maxAmount = 100000;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _statusColor(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.paid:
        return Colors.green;
      case InvoiceStatus.partiallyPaid:
        return Colors.orange;
      case InvoiceStatus.sent:
        return Colors.blue;
      case InvoiceStatus.overdue:
        return Colors.red;
      case InvoiceStatus.cancelled:
        return Colors.grey;
      case InvoiceStatus.draft:
        return Colors.blueGrey;
    }
  }

  String _statusLabel(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.draft:
        return 'Draft';
      case InvoiceStatus.sent:
        return 'Sent';
      case InvoiceStatus.paid:
        return 'Paid';
      case InvoiceStatus.partiallyPaid:
        return 'Partially Paid';
      case InvoiceStatus.overdue:
        return 'Overdue';
      case InvoiceStatus.cancelled:
        return 'Cancelled';
    }
  }

  void _showFilterDialog() {
    var tempStatuses = Set<InvoiceStatus>.from(_selectedStatuses);
    final minController = TextEditingController(
      text: _minAmount.toStringAsFixed(0),
    );
    final maxController = TextEditingController(
      text: _maxAmount.toStringAsFixed(0),
    );

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text(
            'Filter Invoices',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Status',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: InvoiceStatus.values.map((status) {
                  final selected = tempStatuses.contains(status);
                  final color = _statusColor(status);
                  return FilterChip(
                    label: Text(_statusLabel(status)),
                    selected: selected,
                    selectedColor: color.withValues(alpha: 0.2),
                    checkmarkColor: color,
                    onSelected: (value) {
                      setDialogState(() {
                        if (value) {
                          tempStatuses.add(status);
                        } else {
                          tempStatuses.remove(status);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text(
                'Min Amount',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: minController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefixText: 'GHS ',
                  hintText: '0',
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Max Amount',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: maxController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefixText: 'GHS ',
                  hintText: '100000',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedStatuses = {};
                  _minAmount = 0;
                  _maxAmount = 100000;
                });
                Navigator.pop(context);
              },
              child: const Text('Reset'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  _selectedStatuses = tempStatuses;
                  _minAmount = double.tryParse(minController.text) ?? 0;
                  _maxAmount = double.tryParse(maxController.text) ?? 100000;
                });
                Navigator.pop(context);
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search invoices...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                });
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 8),
                AspectRatio(
                  aspectRatio: 1,
                  child: IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: _showFilterDialog,
                    tooltip: 'Filter',
                    style: IconButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).inputDecorationTheme.fillColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: Theme.of(context)
                                .inputDecorationTheme
                                .enabledBorder
                                ?.borderSide ??
                            const BorderSide(color: Color(0xFFD4D4D4)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<InvoiceBloc, InvoiceState>(
            builder: (context, state) {
              if (state is InvoiceLoadingState) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 200),
                    Center(child: CircularProgressIndicator()),
                  ],
                );
              } else if (state is InvoiceListLoadedState) {
                final query = _searchController.text.toLowerCase();
                final invoices = state.invoices.where((invoice) {
                  final matchesSearch = query.isEmpty ||
                      invoice.invoiceNumber.toLowerCase().contains(query) ||
                      (invoice.customer?.name.toLowerCase().contains(query) ??
                          false) ||
                      invoice.totalAmount
                          .toStringAsFixed(2)
                          .contains(query) ||
                      (invoice.issueDate != null &&
                          DateFormat('dd/MM/yyyy')
                              .format(invoice.issueDate!)
                              .contains(query));

                  final matchesStatus = _selectedStatuses.isEmpty ||
                      _selectedStatuses.contains(invoice.status);

                  final matchesAmount = invoice.totalAmount >= _minAmount &&
                      invoice.totalAmount <= _maxAmount;

                  return matchesSearch && matchesStatus && matchesAmount;
                }).toList();

                if (invoices.isEmpty) {
                  final hasFilters = query.isNotEmpty ||
                      _selectedStatuses.isNotEmpty ||
                      _minAmount > 0 ||
                      _maxAmount < 100000;
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 100),
                      Center(
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
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Theme.of(context).disabledColor,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              hasFilters
                                  ? 'Try adjusting your search or filters'
                                  : 'Create your first invoice to get started',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context).disabledColor,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: invoices.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final invoice = invoices[index];
                    final totalProducts =
                        invoice.orders?.expand((o) => o.items).length ?? 0;
                    final formattedDate = invoice.issueDate != null
                        ? DateFormat('dd/MM/yyyy').format(invoice.issueDate!)
                        : 'N/A';
                    return Card(
                      elevation: 0,
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerLowest,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide.none,
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ViewInvoice(invoice: invoice),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'GHC ${invoice.totalAmount.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _statusColor(
                                        invoice.status,
                                      ).withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      _statusLabel(invoice.status),
                                      style: TextStyle(
                                        color: _statusColor(invoice.status),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  HugeIcon(
                                    icon: HugeIcons.strokeRoundedArrowRight01,
                                  ),
                                ],
                              ),
                              Text(
                                invoice.invoiceNumber,
                                style: TextStyle(
                                  fontSize: 14,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 8),
                              RichText(
                                text: TextSpan(
                                  text: 'Billed To: ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          ' ${invoice.customer?.name ?? 'N/A'}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Date: $formattedDate',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '${invoice.orders?.length ?? 0} orders',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(),
                                  const SizedBox(width: 8),
                                  Text(
                                    '$totalProducts products',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (state is InvoiceErrorState) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    const SizedBox(height: 100),
                    Center(
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
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              state.message,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context).disabledColor,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Pull to refresh',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).disabledColor,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 200),
                  Center(child: CircularProgressIndicator()),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
