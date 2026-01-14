import 'invoice_status.dart';
import 'payment_method.dart';
import 'customer_entity.dart';
import 'order_entity.dart';

class Invoice {
  final String id;
  final String invoiceNumber;
  final String businessId;
  final String customerId;
  final Customer? customer;
  final List<Order>? orders;

  // Financial Details - Ghana VAT Structure
  final double subtotal;

  // VAT - 15%
  final double vatRate;
  final double vatAmount;

  // NHIL - 2.5%
  final double nhilRate;
  final double nhilAmount;

  // GETFund Levy - 2.5%
  final double getfundRate;
  final double getfundAmount;

  // Total tax (VAT + NHIL + GETFund = 20%)
  final double totalTax;

  // Final amount
  final double totalAmount;

  // Payment tracking
  final double amountPaid;
  final InvoiceStatus status;
  final PaymentMethod? paymentMethod;
  final DateTime? paymentDate;

  // Dates
  final DateTime? issueDate;
  final DateTime? dueDate;

  // Notes
  final String? notes;

  final DateTime createdAt;
  final DateTime updatedAt;

  Invoice({
    required this.id,
    required this.invoiceNumber,
    required this.businessId,
    required this.customerId,
    this.customer,
    this.orders,
    required this.subtotal,
    this.vatRate = 0.15,
    required this.vatAmount,
    this.nhilRate = 0.025,
    required this.nhilAmount,
    this.getfundRate = 0.025,
    required this.getfundAmount,
    required this.totalTax,
    required this.totalAmount,
    this.amountPaid = 0.0,
    required this.status,
    this.paymentMethod,
    this.paymentDate,
    this.issueDate,
    this.dueDate,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  Invoice copyWith({
    String? id,
    String? invoiceNumber,
    String? businessId,
    String? customerId,
    Customer? customer,
    List<Order>? orders,
    double? subtotal,
    double? vatRate,
    double? vatAmount,
    double? nhilRate,
    double? nhilAmount,
    double? getfundRate,
    double? getfundAmount,
    double? totalTax,
    double? totalAmount,
    double? amountPaid,
    InvoiceStatus? status,
    PaymentMethod? paymentMethod,
    DateTime? paymentDate,
    DateTime? issueDate,
    DateTime? dueDate,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Invoice(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      businessId: businessId ?? this.businessId,
      customerId: customerId ?? this.customerId,
      customer: customer ?? this.customer,
      orders: orders ?? this.orders,
      subtotal: subtotal ?? this.subtotal,
      vatRate: vatRate ?? this.vatRate,
      vatAmount: vatAmount ?? this.vatAmount,
      nhilRate: nhilRate ?? this.nhilRate,
      nhilAmount: nhilAmount ?? this.nhilAmount,
      getfundRate: getfundRate ?? this.getfundRate,
      getfundAmount: getfundAmount ?? this.getfundAmount,
      totalTax: totalTax ?? this.totalTax,
      totalAmount: totalAmount ?? this.totalAmount,
      amountPaid: amountPaid ?? this.amountPaid,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentDate: paymentDate ?? this.paymentDate,
      issueDate: issueDate ?? this.issueDate,
      dueDate: dueDate ?? this.dueDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  double get balanceDue => totalAmount - amountPaid;

  bool get isFullyPaid => amountPaid >= totalAmount;

  bool get isPartiallyPaid => amountPaid > 0 && amountPaid < totalAmount;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Invoice &&
        other.id == id &&
        other.invoiceNumber == invoiceNumber &&
        other.businessId == businessId &&
        other.customerId == customerId &&
        other.status == status &&
        other.totalAmount == totalAmount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        invoiceNumber.hashCode ^
        businessId.hashCode ^
        customerId.hashCode ^
        status.hashCode ^
        totalAmount.hashCode;
  }
}
