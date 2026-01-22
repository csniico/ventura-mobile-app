import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:ventura/core/services/pdf_service.dart';
import 'package:ventura/core/services/toast_service.dart';
import 'package:ventura/features/sales/domain/entities/invoice_entity.dart';
import 'package:ventura/features/sales/domain/entities/order_item_entity.dart';
import 'package:ventura/features/sales/domain/entities/product_entity.dart';

class ViewInvoice extends StatefulWidget {
  const ViewInvoice({super.key, required this.invoice});
  final Invoice invoice;

  @override
  State<ViewInvoice> createState() => _ViewInvoiceState();
}

class _ViewInvoiceState extends State<ViewInvoice> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
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

  List<Product>? getProductsByIds(List<String> ids) {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    String invoiceNumber = widget.invoice.invoiceNumber;
    String customerName = widget.invoice.customer?.name ?? 'Unknown Customer';
    String customerEmail = widget.invoice.customer?.email ?? 'No Email';
    String customerPhone = widget.invoice.customer?.phone ?? 'No Phone';
    DateTime? invoiceDate = widget.invoice.issueDate;
    int totalOrders = widget.invoice.orders?.length ?? 0;
    List<OrderItem>? products = widget.invoice.orders
        ?.expand((order) => order.items)
        .toList();
    double subtotal = widget.invoice.subtotal;
    double vatRate = widget.invoice.vatRate;
    double vatAmount = widget.invoice.vatAmount;
    double nhilRate = widget.invoice.nhilRate;
    double nhilAmount = widget.invoice.nhilAmount;
    double getFundRate = widget.invoice.getfundRate;
    double getFundAmount = widget.invoice.getfundAmount;
    double totalAmount = widget.invoice.totalAmount;
    double totalTax = widget.invoice.totalTax;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
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
        title: Text(
          'Invoice Details',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Invoice Number: ', invoiceNumber, context),
              _buildDetailRow(
                'Issue Date: ',
                readableDate(invoiceDate!),
                context,
              ),
              _buildDetailRow(
                'Total Orders: ',
                totalOrders.toString(),
                context,
              ),
              _buildDetailRow(
                'Total Products: ',
                products?.length.toString() ?? '0',
                context,
              ),
              _buildDetailRow('Customer Name: ', customerName, context),
              _buildDetailRow('Customer Email: ', customerEmail, context),
              _buildDetailRow('Customer Phone: ', customerPhone, context),

              // products list
              const SizedBox(height: 8.0),
              ...?products?.map((orderItem) {
                return _buildDetailRow(
                  '${orderItem.quantity.toString()} x ${orderItem.name}',
                  'GHC${orderItem.price.toStringAsFixed(2)}',
                  context,
                );
              }),
              const SizedBox(height: 8.0),
              _buildDetailRow(
                'Subtotal: ',
                subtotal.toStringAsFixed(2),
                context,
              ),
              _buildDetailRow(
                'VAT (${vatRate.toStringAsFixed(2)}%): ',
                vatAmount.toStringAsFixed(2),
                context,
              ),
              _buildDetailRow(
                'NHIL (${nhilRate.toStringAsFixed(2)}%): ',
                nhilAmount.toStringAsFixed(2),
                context,
              ),
              _buildDetailRow(
                'GETFund (${getFundRate.toStringAsFixed(2)}%): ',
                getFundAmount.toStringAsFixed(2),
                context,
              ),
              _buildDetailRow(
                'Total Tax: ',
                totalTax.toStringAsFixed(2),
                context,
              ),
              _buildDetailRow(
                'Total Amount: ',
                totalAmount.toStringAsFixed(2),
                context,
              ),

              // generate invoice button
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        setState(() {
                          isLoading = true;
                        });
                        _generatePdf();
                        setState(() {
                          isLoading = false;
                        });
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isLoading
                      ? Colors.grey
                      : Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    vertical: 18.0,
                    horizontal: 16.0,
                  ),
                ),
                child: Center(
                  child: Text(
                    isLoading ? 'Generating PDF...' : 'Generate PDF Invoice',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
          Text(value, style: TextStyle()),
        ],
      ),
    );
  }

  void _generatePdf() async {
    ToastService.showInfo('Generating PDF invoice...');
    final pdfFile = PdfService().generate(widget.invoice);
  }

  void _shareInvoice(BuildContext context) {
    // TODO: Implement sharing logic
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Sharing invoice...')));
  }

  void _markAsFulfilled(BuildContext context) {
    // TODO: Implement mark as fulfilled logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Marking invoice as fulfilled...')),
    );
  }
}
