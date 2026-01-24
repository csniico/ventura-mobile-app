import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ventura/features/sales/domain/entities/invoice_entity.dart';
import 'package:ventura/features/sales/presentation/bloc/invoice_bloc.dart';
import 'package:ventura/features/sales/presentation/pages/view_invoice.dart';
import 'package:ventura/init_dependencies.dart';

class OverdueInvoicesPage extends StatefulWidget {
  const OverdueInvoicesPage({super.key});

  @override
  State<OverdueInvoicesPage> createState() => _OverdueInvoicesPageState();
}

class _OverdueInvoicesPageState extends State<OverdueInvoicesPage> {
  late final InvoiceBloc _invoiceBloc;
  final currencyFormat = NumberFormat.currency(
    symbol: 'GHC ',
    decimalDigits: 2,
  );
  List<Invoice> overdueInvoices = [];

  @override
  void initState() {
    super.initState();
    _invoiceBloc = serviceLocator<InvoiceBloc>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadInvoices();
  }

  void _loadInvoices() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      final businessId = authState.user.business?.id;
      if (businessId != null) {
        _invoiceBloc.add(InvoiceGetListEvent(businessId: businessId));
      }
    }
  }

  @override
  void dispose() {
    _invoiceBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        leading: IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        title: const Text('Overdue Invoices'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadInvoices),
        ],
      ),
      body: BlocProvider.value(
        value: _invoiceBloc,
        child: BlocBuilder<InvoiceBloc, InvoiceState>(
          builder: (context, state) {
            if (state is InvoiceLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is InvoiceErrorState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading invoices',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadInvoices,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is InvoiceListLoadedState) {
              final now = DateTime.now();
              // Filter unpaid invoices that are past due date
              overdueInvoices = state.invoices.where((invoice) {
                final isUnpaid = invoice.status.name.toLowerCase() != 'paid';
                final dueDate = invoice.dueDate;
                final isOverdue = dueDate != null && dueDate.isBefore(now);
                return isUnpaid && isOverdue;
              }).toList();

              if (overdueInvoices.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedCheckmarkCircle01,
                        color: Colors.green,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'All Clear!',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No overdue invoices',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async => _loadInvoices(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: overdueInvoices.length,
                  itemBuilder: (context, index) {
                    final invoice = overdueInvoices[index];
                    return _buildInvoiceCard(invoice);
                  },
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildInvoiceCard(Invoice invoice) {
    final dueDate = invoice.dueDate;
    final dueDateStr = dueDate != null
        ? DateFormat('MMM dd, yyyy').format(dueDate)
        : 'No due date';
    final daysOverdue = dueDate != null
        ? DateTime.now().difference(dueDate).inDays
        : 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: InkWell(
        onTap: () => _navigateToInvoiceDetails(invoice),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Invoice #${invoice.invoiceNumber}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          invoice.customer?.name ?? 'Unknown Customer',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Text(
                      '$daysOverdue DAYS OVERDUE',
                      style: TextStyle(
                        color: Colors.red[700],
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedCalendar03,
                    color: Colors.red,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Due: $dueDateStr',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                currencyFormat.format(invoice.totalAmount),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _sendReminder(invoice),
                      icon: const Icon(Icons.mail_outline, size: 18),
                      label: const Text('Remind'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        side: const BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _markAsPaid(invoice),
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Mark Paid'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToInvoiceDetails(Invoice invoice) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ViewInvoice(invoice: invoice)),
    );
  }

  void _sendReminder(Invoice invoice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Payment Reminder'),
        content: Text(
          'Send a payment reminder to ${invoice.customer?.name ?? 'the customer'} for Invoice #${invoice.invoiceNumber}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement email/SMS reminder functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payment reminder sent successfully'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            icon: const Icon(Icons.send),
            label: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _markAsPaid(Invoice invoice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark as Paid'),
        content: Text('Mark Invoice #${invoice.invoiceNumber} as paid?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              final authState = context.read<AuthBloc>().state;
              if (authState is Authenticated) {
                final businessId = authState.user.business?.id ?? '';
                _invoiceBloc.add(
                  InvoiceUpdatePaymentEvent(
                    invoiceId: invoice.id,
                    businessId: businessId,
                    paymentMethod: 'cash',
                    amountPaid: invoice.totalAmount,
                  ),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Invoice marked as paid'),
                    backgroundColor: Colors.green,
                  ),
                );

                _loadInvoices();
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
