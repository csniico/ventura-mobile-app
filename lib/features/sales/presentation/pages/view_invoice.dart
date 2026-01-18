import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
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
        backgroundColor: Theme.of(context).colorScheme.primary,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(8.0),
          child: const SizedBox(height: 8.0),
        ),
        leading: IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 30,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount and Status Card
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          'GHC ${invoice.totalAmount.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(invoice.invoiceNumber),
                      ],
                    ),
                  ),
                ),
              ),

              // Customer Information
              if (invoice.customer != null) ...[
                Padding(padding: const EdgeInsets.only(left: 12.0, top: 8.0)),
                Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Billed to ${invoice.customer!.name}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        if (invoice.customer!.email != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            'Email: ${invoice.customer!.email}',
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                              fontSize: 14,
                            ),
                          ),
                        ],
                        if (invoice.customer!.phone != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Phone: ${invoice.customer!.phone}',
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],

              // Products Section
              if (invoice.orders != null && invoice.orders!.isNotEmpty) ...[
                Padding(padding: const EdgeInsets.only(left: 16.0, top: 8.0)),
                Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...invoice.orders!.map((order) {
                          if (order.items.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (invoice.orders!.length > 1) ...[
                                Text(
                                  'Order #${order.orderNumber}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                              Table(
                                border: TableBorder.all(
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.2),
                                  width: 1,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                columnWidths: const {
                                  0: FlexColumnWidth(4),
                                  1: FlexColumnWidth(1),
                                  2: FlexColumnWidth(2.5),
                                },
                                children: [
                                  TableRow(
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.surfaceContainerHighest,
                                    ),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          'Title',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          'Qty',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                            fontSize: 14,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          'Unit Price',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                            fontSize: 14,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ...order.items.map(
                                    (item) => TableRow(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            item.product?.name ??
                                                'Unknown Product',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            '${item.quantity}',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            'GHC ${(item.subTotal / item.quantity).toStringAsFixed(2)}',
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],

              // Amount Breakdown
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 8.0,
                  left: 16.0,
                  top: 8.0,
                ),
              ),
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
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
                      const SizedBox(height: 12),
                      _buildAmountRow(
                        'Total',
                        invoice.totalAmount,
                        isBold: true,
                      ),
                      if (invoice.amountPaid > 0) ...[
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
              ),

              // Notes
              if (invoice.notes != null && invoice.notes!.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8.0,
                    left: 16.0,
                    top: 16.0,
                  ),
                  child: Text(
                    'Notes',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 16.0,
                    ),
                    child: Text(
                      invoice.notes!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountRow(String label, double amount, {bool isBold = false}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            fontSize: isBold ? 16 : 14,
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return CustomPaint(
                  size: Size(constraints.maxWidth, 1),
                  painter: DottedLinePainter(),
                );
              },
            ),
          ),
        ),
        Text(
          'GHC ${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            fontSize: isBold ? 16 : 14,
          ),
        ),
      ],
    );
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.5)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 3.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
