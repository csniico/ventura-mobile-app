import 'package:flutter/material.dart';
import 'package:ventura/features/sales/domain/entities/invoice_entity.dart';
import 'package:ventura/features/sales/presentation/pages/edit_invoice.dart';

class ViewInvoice extends StatelessWidget {
  const ViewInvoice({super.key, required this.invoice});
  final Invoice invoice;

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'overdue':
        return Colors.red;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Invoice Details'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditInvoice(invoiceId: invoice.id),
                ),
              );
            },
            child: const Text('Edit'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Top Section - Amount and Invoice Number
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        'GHC${invoice.totalAmount.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        invoice.invoiceNumber,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(
                                invoice.status.name,
                              ).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              invoice.status.name.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _getStatusColor(invoice.status.name),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (invoice.paymentDate != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          'Paid at ${_formatDate(invoice.paymentDate!)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ] else if (invoice.dueDate != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          'Due ${_formatDate(invoice.dueDate!)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ],
                  ),
                ),

                const Divider(height: 1),

                // Customer Information
                if (invoice.customer != null) ...[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Billed to',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          invoice.customer!.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        if (invoice.customer!.email != null) ...[
                          const SizedBox(height: 4),
                          Text(invoice.customer!.email!),
                        ],
                        if (invoice.customer!.phone != null) ...[
                          const SizedBox(height: 4),
                          Text(invoice.customer!.phone!),
                        ],
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                ],

                // Amount Breakdown
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAmountRow('Subtotal', invoice.subtotal),
                      const SizedBox(height: 12),
                      _buildAmountRow(
                        'VAT (${(invoice.vatRate * 100).toStringAsFixed(1)}%)',
                        invoice.vatAmount,
                      ),
                      const SizedBox(height: 12),
                      _buildAmountRow(
                        'NHIL (${(invoice.nhilRate * 100).toStringAsFixed(1)}%)',
                        invoice.nhilAmount,
                      ),
                      const SizedBox(height: 12),
                      _buildAmountRow(
                        'GETFund (${(invoice.getfundRate * 100).toStringAsFixed(1)}%)',
                        invoice.getfundAmount,
                      ),
                      const Divider(height: 24),
                      _buildAmountRow(
                        'Total',
                        invoice.totalAmount,
                        isBold: true,
                      ),
                      if (invoice.amountPaid > 0) ...[
                        const Divider(height: 24),
                        _buildAmountRow('Amount Paid', invoice.amountPaid),
                        const SizedBox(height: 12),
                        _buildAmountRow(
                          'Amount Due',
                          invoice.totalAmount - invoice.amountPaid,
                          isBold: true,
                        ),
                      ],
                    ],
                  ),
                ),

                // Dates Section
                if (invoice.issueDate != null) ...[
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        if (invoice.issueDate != null)
                          _buildInfoRow(
                            'Issue Date',
                            _formatDate(invoice.issueDate!),
                          ),
                        if (invoice.dueDate != null) ...[
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            'Due Date',
                            _formatDate(invoice.dueDate!),
                          ),
                        ],
                        if (invoice.paymentDate != null) ...[
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            'Payment Date',
                            _formatDate(invoice.paymentDate!),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],

                // Notes
                if (invoice.notes != null && invoice.notes!.isNotEmpty) ...[
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notes',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        Text(invoice.notes!),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 80), // Space for bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmountRow(String label, double amount, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            fontSize: isBold ? 16 : 14,
          ),
        ),
        Text(
          '₵${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            fontSize: isBold ? 16 : 14,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
