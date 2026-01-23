import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:ventura/features/sales/domain/entities/invoice_entity.dart';

class PdfService {
  Future<File> generate(
    Invoice invoice, {
    required String businessName,
    String? businessEmail,
    String? businessPhone,
    String? businessAddress,
    String? businessLogoUrl,
  }) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('dd MMM yyyy');
    // Use ASCII-safe symbol to avoid missing glyphs in PDF fonts
    final currencyFormat = NumberFormat.currency(
      symbol: 'GHC ',
      decimalDigits: 2,
    );

    final pw.ImageProvider? businessLogo = await _loadNetworkImage(
      businessLogoUrl,
    );
    final DateTime displayDate =
        invoice.issueDate ?? invoice.paymentDate ?? DateTime.now();
    final String paymentMethodLabel =
        invoice.paymentMethod?.displayName ?? 'Not specified';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [
            _buildTopBar(
              businessName: businessName,
              businessLogo: businessLogo,
              invoiceNumber: invoice.invoiceNumber,
            ),
            pw.SizedBox(height: 24),
            pw.Text(
              'INVOICE',
              style: pw.TextStyle(
                fontSize: 28,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.black,
              ),
            ),
            pw.SizedBox(height: 14),
            _buildDateRow(dateFormat.format(displayDate)),
            pw.SizedBox(height: 16),
            _buildPartiesSection(
              invoice: invoice,
              businessName: businessName,
              businessEmail: businessEmail,
              businessPhone: businessPhone,
              businessAddress: businessAddress,
            ),
            pw.SizedBox(height: 22),
            _buildItemsTable(invoice, currencyFormat),
            pw.SizedBox(height: 18),
            _buildTotalsSection(invoice, currencyFormat),
            pw.SizedBox(height: 18),
            _buildPaymentNoteSection(
              paymentMethodLabel: paymentMethodLabel,
              notes: invoice.notes,
            ),
          ];
        },
      ),
    );

    // Save the PDF file
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/invoice_${invoice.invoiceNumber}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  pw.Widget _buildTopBar({
    required String businessName,
    required pw.ImageProvider? businessLogo,
    required String invoiceNumber,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Row(
          children: [
            if (businessLogo != null)
              pw.Container(
                width: 48,
                height: 48,
                decoration: pw.BoxDecoration(
                  shape: pw.BoxShape.circle,
                  image: pw.DecorationImage(
                    image: businessLogo,
                    fit: pw.BoxFit.cover,
                  ),
                ),
              ),
            if (businessLogo != null) pw.SizedBox(width: 12),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  businessName,
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  'YOUR LOGO',
                  style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
                ),
              ],
            ),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              'NO. $invoiceNumber',
              style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildDateRow(String dateText) {
    return pw.Row(
      children: [
        pw.Text(
          'Date: ',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
        ),
        pw.Text(dateText, style: const pw.TextStyle(fontSize: 11)),
      ],
    );
  }

  pw.Widget _buildPartiesSection({
    required Invoice invoice,
    required String businessName,
    String? businessEmail,
    String? businessPhone,
    String? businessAddress,
  }) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _sectionTitle('Billed to:'),
              pw.SizedBox(height: 6),
              pw.Text(
                invoice.customer?.name ?? 'Customer',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              if (invoice.customer?.email != null)
                pw.Text(invoice.customer!.email!),
              if (invoice.customer?.phone != null)
                pw.Text(invoice.customer!.phone!),
            ],
          ),
        ),
        pw.SizedBox(width: 24),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _sectionTitle('From:'),
              pw.SizedBox(height: 6),
              pw.Text(
                businessName,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              if (businessAddress != null && businessAddress.isNotEmpty)
                pw.Text(businessAddress),
              if (businessEmail != null && businessEmail.isNotEmpty)
                pw.Text(businessEmail),
              if (businessPhone != null && businessPhone.isNotEmpty)
                pw.Text(businessPhone),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildItemsTable(Invoice invoice, NumberFormat currencyFormat) {
    if (invoice.orders == null || invoice.orders!.isEmpty) {
      return pw.SizedBox();
    }

    // Extract all items from all orders
    final allItems = invoice.orders!.expand((order) => order.items).toList();

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      columnWidths: {
        0: const pw.FlexColumnWidth(3),
        1: const pw.FlexColumnWidth(1),
        2: const pw.FlexColumnWidth(1.5),
        3: const pw.FlexColumnWidth(1.5),
      },
      children: [
        // Header Row
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _buildTableCell('Item', isHeader: true),
            _buildTableCell('Qty', isHeader: true, align: pw.TextAlign.center),
            _buildTableCell('Price', isHeader: true, align: pw.TextAlign.right),
            _buildTableCell('Total', isHeader: true, align: pw.TextAlign.right),
          ],
        ),
        // Item Rows
        ...allItems.map(
          (item) => pw.TableRow(
            children: [
              _buildTableCell(item.name),
              _buildTableCell(
                item.quantity.toString(),
                align: pw.TextAlign.center,
              ),
              _buildTableCell(
                currencyFormat.format(item.price),
                align: pw.TextAlign.right,
              ),
              _buildTableCell(
                currencyFormat.format(item.subTotal),
                align: pw.TextAlign.right,
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildTableCell(
    String text, {
    bool isHeader = false,
    pw.TextAlign align = pw.TextAlign.left,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          fontSize: isHeader ? 11 : 10,
        ),
      ),
    );
  }

  pw.Widget _buildTotalsSection(Invoice invoice, NumberFormat currencyFormat) {
    final totalAmount = currencyFormat.format(invoice.totalAmount);
    final subtotal = currencyFormat.format(invoice.subtotal);
    final tax = currencyFormat.format(invoice.totalTax);

    return pw.Container(
      decoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: PdfColors.grey400, width: 0.6),
      ),
      padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: pw.Column(
        children: [
          _buildAmountRow('Subtotal', subtotal),
          _buildAmountRow('Total tax', tax),
          pw.Divider(thickness: 1, color: PdfColors.grey400),
          _buildAmountRow('Total', totalAmount, isBold: true),
        ],
      ),
    );
  }

  pw.Widget _buildAmountRow(
    String label,
    String amount, {
    bool isBold = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              fontSize: 11,
            ),
          ),
          pw.Text(
            amount,
            style: pw.TextStyle(
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPaymentNoteSection({
    required String paymentMethodLabel,
    String? notes,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          children: [
            pw.Text(
              'Payment method: ',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
            ),
            pw.Text(
              paymentMethodLabel,
              style: const pw.TextStyle(fontSize: 11),
            ),
          ],
        ),
        if (notes != null && notes.isNotEmpty) ...[
          pw.SizedBox(height: 8),
          pw.Text(
            'Note: ',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
          ),
          pw.Text(notes, style: const pw.TextStyle(fontSize: 11)),
        ],
      ],
    );
  }

  pw.Text _sectionTitle(String text) {
    return pw.Text(
      text,
      style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
    );
  }

  Future<pw.ImageProvider?> _loadNetworkImage(String? url) async {
    if (url == null || url.isEmpty) return null;
    try {
      final Uri uri = Uri.parse(url);
      final HttpClient client = HttpClient();
      final HttpClientRequest request = await client.getUrl(uri);
      final HttpClientResponse response = await request.close();
      if (response.statusCode == 200) {
        final BytesBuilder builder = BytesBuilder();
        await for (final chunk in response) {
          builder.add(chunk);
        }
        return pw.MemoryImage(builder.takeBytes());
      }
    } catch (_) {
      // ignore logo failures; continue without logo
    }
    return null;
  }
}
