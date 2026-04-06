import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/services/toast_service.dart';
import 'package:ventura/core/services/user_service.dart';
import 'package:ventura/features/sales/domain/entities/invoice_entity.dart';
import 'package:ventura/features/sales/domain/entities/invoice_status.dart';
import 'package:ventura/features/sales/domain/entities/payment_method.dart';
import 'package:ventura/features/sales/presentation/bloc/invoice_bloc.dart';
import 'package:ventura/init_dependencies.dart';

class EditInvoice extends StatefulWidget {
  const EditInvoice({super.key, required this.invoice});
  final Invoice invoice;

  @override
  State<EditInvoice> createState() => _EditInvoiceState();
}

class _EditInvoiceState extends State<EditInvoice> {
  late final InvoiceBloc _invoiceBloc;
  late final TextEditingController _amountController;
  late PaymentMethod _selectedPaymentMethod;
  DateTime? _paymentDate;
  late String _businessId;

  @override
  void initState() {
    super.initState();
    _invoiceBloc = serviceLocator<InvoiceBloc>();
    _amountController = TextEditingController(
      text: widget.invoice.amountPaid > 0
          ? widget.invoice.amountPaid.toStringAsFixed(2)
          : '',
    );
    _selectedPaymentMethod =
        widget.invoice.paymentMethod ?? PaymentMethod.cash;
    _paymentDate = widget.invoice.paymentDate;
    _businessId = '';
    _loadBusinessId();
  }

  Future<void> _loadBusinessId() async {
    final user = await UserService().getUser();
    if (mounted && user != null) {
      setState(() {
        _businessId = user.businessId;
      });
    }
  }

  @override
  void dispose() {
    _invoiceBloc.close();
    _amountController.dispose();
    super.dispose();
  }

  bool get _isLocked =>
      widget.invoice.status == InvoiceStatus.paid ||
      widget.invoice.status == InvoiceStatus.cancelled;

  void _submit() {
    final raw = _amountController.text.trim();
    final amount = double.tryParse(raw);
    if (amount == null || amount < 0) {
      ToastService.showError('Enter a valid amount');
      return;
    }
    if (amount > widget.invoice.totalAmount) {
      ToastService.showError(
        'Amount cannot exceed total of ${widget.invoice.totalAmount.toStringAsFixed(2)}',
      );
      return;
    }
    _invoiceBloc.add(
      InvoiceUpdatePaymentEvent(
        invoiceId: widget.invoice.id,
        businessId: _businessId,
        amountPaid: amount,
        paymentMethod: _selectedPaymentMethod.toJson(),
        paymentDate: _paymentDate,
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _paymentDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _paymentDate = picked);
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _invoiceBloc,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(8.0),
            child: SizedBox(height: 8.0),
          ),
          title: Text(
            'Record Payment',
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          leading: IconButton(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedArrowLeft01,
              color: Theme.of(context).colorScheme.onSurface,
              size: 30,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocConsumer<InvoiceBloc, InvoiceState>(
          listener: (context, state) {
            if (state is InvoicePaymentUpdateSuccessState) {
              ToastService.showSuccess('Payment recorded');
              Navigator.pop(context, state.invoice);
            } else if (state is InvoiceErrorState) {
              ToastService.showError(state.message);
            }
          },
          builder: (context, state) {
            final isUpdating = state is InvoiceLoadingState;

            if (_isLocked) {
              final lockedLabel = _statusLabel(widget.invoice.status);
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_outline,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Invoice $lockedLabel',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This invoice cannot be updated because it is ${lockedLabel.toLowerCase()}.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary card
                  Card(
                    color: Theme.of(context).colorScheme.surfaceContainerLowest,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _SummaryRow(
                            label: 'Total Amount',
                            value:
                                'GHS ${widget.invoice.totalAmount.toStringAsFixed(2)}',
                          ),
                          const SizedBox(height: 8),
                          _SummaryRow(
                            label: 'Amount Paid',
                            value:
                                'GHS ${widget.invoice.amountPaid.toStringAsFixed(2)}',
                          ),
                          const Divider(height: 20),
                          _SummaryRow(
                            label: 'Balance Due',
                            value:
                                'GHS ${widget.invoice.balanceDue.toStringAsFixed(2)}',
                            highlight: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Amount Paid',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      prefixText: 'GHS ',
                      hintText: '0.00',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Payment Method',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<PaymentMethod>(
                    value: _selectedPaymentMethod,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: PaymentMethod.values
                        .map(
                          (m) => DropdownMenuItem(
                            value: m,
                            child: Text(m.displayName),
                          ),
                        )
                        .toList(),
                    onChanged: (m) {
                      if (m != null) setState(() => _selectedPaymentMethod = m);
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Payment Date',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _pickDate,
                    borderRadius: BorderRadius.circular(8),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: const Icon(Icons.calendar_today, size: 18),
                      ),
                      child: Text(
                        _paymentDate != null
                            ? '${_paymentDate!.day}/${_paymentDate!.month}/${_paymentDate!.year}'
                            : 'Select date (optional)',
                        style: TextStyle(
                          color: _paymentDate != null
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isUpdating ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isUpdating
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Record Payment',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: highlight ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: highlight ? FontWeight.w700 : FontWeight.w600,
            color: highlight
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
