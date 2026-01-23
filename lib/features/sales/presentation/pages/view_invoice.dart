import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ventura/core/services/pdf_service.dart';
import 'package:ventura/core/services/toast_service.dart';
import 'package:ventura/core/services/user_service.dart';
import 'package:ventura/features/sales/presentation/pages/edit_invoice.dart';
import 'package:ventura/features/sales/domain/entities/invoice_entity.dart';
import 'package:ventura/features/sales/domain/entities/invoice_status.dart';
import 'package:ventura/features/sales/domain/entities/order_item_entity.dart';

class ViewInvoice extends StatefulWidget {
  const ViewInvoice({super.key, required this.invoice});
  final Invoice invoice;

  @override
  State<ViewInvoice> createState() => _ViewInvoiceState();
}

class _ViewInvoiceState extends State<ViewInvoice> {
  bool isLoading = false;
  bool isSharing = false;
  late Invoice _invoice;

  @override
  void initState() {
    super.initState();
    _invoice = widget.invoice;
  }

  /// Formats a [DateTime] object into a readable string format.
  /// For example, 1.1.2024 becomes "1st January 2024".
  String readableDate(DateTime date) {
    final day = date.day;
    final month = DateFormat.MMMM().format(date);
    final year = date.year;

    String daySuffix;
    if (day >= 11 && day <= 13) {
      daySuffix = 'th';
    } else {
      switch (day % 10) {
        case 1:
          daySuffix = 'st';
          break;
        case 2:
          daySuffix = 'nd';
          break;
        case 3:
          daySuffix = 'rd';
          break;
        default:
          daySuffix = 'th';
      }
    }

    return '$day$daySuffix $month $year';
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      symbol: 'GHC ',
      decimalDigits: 2,
    );
    final allItems =
        _invoice.orders?.expand((order) => order.items).toList() ??
        <OrderItem>[];
    final paidLabel = _invoice.paymentDate != null
        ? 'Paid ${readableDate(_invoice.paymentDate!)}'
        : _invoice.issueDate != null
        ? 'Issued ${readableDate(_invoice.issueDate!)}'
        : 'No date set';

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(8.0),
          child: SizedBox(height: 8.0),
        ),
        leading: IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 30,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Invoice Details',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedPencilEdit02,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 26,
            ),
            onPressed: () async {
              final updated = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditInvoice(invoice: _invoice),
                ),
              );

              if (mounted && updated is Invoice) {
                setState(() {
                  _invoice = updated;
                });
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.all(12.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryCard(
                    context: context,
                    amount: currencyFormat.format(_invoice.totalAmount),
                    title:
                        _invoice.customer?.name ??
                        'Invoice ${_invoice.invoiceNumber}',
                    subtitle: paidLabel,
                    status: _invoice.status,
                  ),
                  const SizedBox(height: 12),
                  _buildPaymentDetailsCard(_invoice, currencyFormat),
                  const SizedBox(height: 12),
                  if (allItems.isNotEmpty)
                    _buildItemsCard(allItems, currencyFormat),
                  const SizedBox(height: 12),
                  _buildTotalsCard(_invoice, currencyFormat),
                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton.icon(
                        onPressed: isLoading || isSharing ? null : _generatePdf,
                        icon: const Icon(Icons.picture_as_pdf_outlined),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isLoading || isSharing
                              ? Colors.grey
                              : Theme.of(context).colorScheme.primary,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 16.0,
                          ),
                        ),
                        label: Text(
                          isLoading ? 'Generating PDF...' : 'View Invoice PDF',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: isLoading || isSharing
                            ? null
                            : _shareInvoice,
                        icon: const Icon(Icons.ios_share_rounded),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isLoading || isSharing
                              ? Colors.grey
                              : Theme.of(context).colorScheme.secondary,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 16.0,
                          ),
                        ),
                        label: Text(
                          isSharing
                              ? 'Preparing to share...'
                              : 'Share Invoice PDF',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required BuildContext context,
    required String amount,
    required String title,
    required String subtitle,
    required InvoiceStatus status,
  }) {
    final statusColor = _statusColor(status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Billed To:',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _statusLabel(status),
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    amount,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetailsCard(
    Invoice invoice,
    NumberFormat currencyFormat,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Details',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          _infoRow('Invoice number', invoice.invoiceNumber),
          _infoRow(
            'Payment method',
            invoice.paymentMethod?.displayName ?? 'Not specified',
          ),
          _infoRow('Amount paid', currencyFormat.format(invoice.amountPaid)),
        ],
      ),
    );
  }

  Widget _buildItemsCard(List<OrderItem> items, NumberFormat currencyFormat) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Items',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Qty ${item.quantity} · ${currencyFormat.format(item.price)} each',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.65),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    currencyFormat.format(item.subTotal),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTotalsCard(Invoice invoice, NumberFormat currencyFormat) {
    final balance = invoice.totalAmount - invoice.amountPaid;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Summary',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          _infoRow('Subtotal', currencyFormat.format(invoice.subtotal)),
          _infoRow('Total tax', currencyFormat.format(invoice.totalTax)),
          _infoRow(
            'Total amount',
            currencyFormat.format(invoice.totalAmount),
            isBold: true,
          ),
          _infoRow('Amount paid', currencyFormat.format(invoice.amountPaid)),
          _infoRow(
            'Balance due',
            currencyFormat.format(balance < 0 ? 0 : balance),
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.75),
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 13,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
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

  ({
    String name,
    String? email,
    String? phone,
    String? address,
    String? logoUrl,
  })
  _businessData() {
    final business = UserService().user?.business;
    return (
      name: business?.name ?? 'Your Business',
      email: business?.email,
      phone: business?.phone,
      address: business?.address,
      logoUrl: business?.logo,
    );
  }

  void _generatePdf() async {
    setState(() {
      isLoading = true;
    });

    try {
      ToastService.showInfo('Generating PDF invoice...');
      final business = _businessData();

      final pdfFile = await PdfService().generate(
        _invoice,
        businessName: business.name,
        businessEmail: business.email,
        businessPhone: business.phone,
        businessAddress: business.address,
        businessLogoUrl: business.logoUrl,
      );

      if (!mounted) return;

      ToastService.showSuccess('PDF generated successfully!');

      // Open the PDF file with the default system viewer
      final result = await OpenFile.open(pdfFile.path);

      if (result.type != ResultType.done) {
        if (!mounted) return;
        ToastService.showError('Could not open PDF: ${result.message}');
      }
    } catch (e) {
      if (!mounted) return;
      ToastService.showError('Failed to generate PDF: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _shareInvoice() async {
    setState(() {
      isSharing = true;
    });

    try {
      ToastService.showInfo('Preparing invoice PDF for sharing...');
      final business = _businessData();

      final pdfFile = await PdfService().generate(
        _invoice,
        businessName: business.name,
        businessEmail: business.email,
        businessPhone: business.phone,
        businessAddress: business.address,
        businessLogoUrl: business.logoUrl,
      );

      if (!mounted) return;

      await Share.shareXFiles([
        XFile(pdfFile.path),
      ], text: 'Invoice ${_invoice.invoiceNumber}');
    } catch (e) {
      if (!mounted) return;
      ToastService.showError('Failed to share PDF: $e');
    } finally {
      if (mounted) {
        setState(() {
          isSharing = false;
        });
      }
    }
  }
}
