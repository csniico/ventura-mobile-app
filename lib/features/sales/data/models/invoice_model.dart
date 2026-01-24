import 'package:ventura/features/sales/domain/entities/invoice_entity.dart';
import 'package:ventura/features/sales/domain/entities/invoice_status.dart';
import 'package:ventura/features/sales/domain/entities/payment_method.dart';
import 'package:ventura/features/sales/data/models/customer_model.dart';
import 'package:ventura/features/sales/data/models/order_model.dart';

class InvoiceModel extends Invoice {
  InvoiceModel({
    required super.id,
    required super.invoiceNumber,
    required super.businessId,
    required super.customerId,
    super.customer,
    super.orders,
    required super.subtotal,
    super.vatRate = 0.15,
    required super.vatAmount,
    super.nhilRate = 0.025,
    required super.nhilAmount,
    super.getfundRate = 0.025,
    required super.getfundAmount,
    required super.totalTax,
    required super.totalAmount,
    super.amountPaid = 0.0,
    required super.status,
    super.paymentMethod,
    super.paymentDate,
    super.issueDate,
    super.dueDate,
    super.notes,
    required super.createdAt,
    required super.updatedAt,
  });

  factory InvoiceModel.empty() {
    return InvoiceModel(
      id: '',
      invoiceNumber: '',
      businessId: '',
      customerId: '',
      subtotal: 0.0,
      vatAmount: 0.0,
      nhilAmount: 0.0,
      getfundAmount: 0.0,
      totalTax: 0.0,
      totalAmount: 0.0,
      status: InvoiceStatus.draft,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'] ?? '',
      invoiceNumber: json['invoiceNumber'] ?? '',
      businessId: json['businessId'] ?? '',
      customerId: json['customerId'] ?? '',
      customer: json['customer'] != null && json['customer'] is Map
          ? CustomerModel.fromJson(json['customer'] as Map<String, dynamic>)
          : null,
      orders: json['orders'] != null && json['orders'] is List
          ? (json['orders'] as List)
                .where((order) => order != null && order is Map)
                .map(
                  (order) => OrderModel.fromJson(order as Map<String, dynamic>),
                )
                .toList()
          : null,
      subtotal: (json['subtotal'] is String)
          ? double.parse(json['subtotal'])
          : (json['subtotal'] ?? 0.0).toDouble(),
      vatRate: (json['vatRate'] is String)
          ? double.parse(json['vatRate'])
          : (json['vatRate'] ?? 0.15).toDouble(),
      vatAmount: (json['vatAmount'] is String)
          ? double.parse(json['vatAmount'])
          : (json['vatAmount'] ?? 0.0).toDouble(),
      nhilRate: (json['nhilRate'] is String)
          ? double.parse(json['nhilRate'])
          : (json['nhilRate'] ?? 0.025).toDouble(),
      nhilAmount: (json['nhilAmount'] is String)
          ? double.parse(json['nhilAmount'])
          : (json['nhilAmount'] ?? 0.0).toDouble(),
      getfundRate: (json['getfundRate'] is String)
          ? double.parse(json['getfundRate'])
          : (json['getfundRate'] ?? 0.025).toDouble(),
      getfundAmount: (json['getfundAmount'] is String)
          ? double.parse(json['getfundAmount'])
          : (json['getfundAmount'] ?? 0.0).toDouble(),
      totalTax: (json['totalTax'] is String)
          ? double.parse(json['totalTax'])
          : (json['totalTax'] ?? 0.0).toDouble(),
      totalAmount: (json['totalAmount'] is String)
          ? double.parse(json['totalAmount'])
          : (json['totalAmount'] ?? 0.0).toDouble(),
      amountPaid: (json['amountPaid'] is String)
          ? double.parse(json['amountPaid'])
          : (json['amountPaid'] ?? 0.0).toDouble(),
      status: InvoiceStatus.fromJson(json['status'] ?? 'DRAFT'),
      paymentMethod: json['paymentMethod'] != null
          ? PaymentMethod.fromJson(json['paymentMethod'])
          : null,
      paymentDate: json['paymentDate'] != null
          ? DateTime.parse(json['paymentDate'])
          : null,
      issueDate: json['issueDate'] != null
          ? DateTime.parse(json['issueDate'])
          : null,
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      notes: json['notes'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  factory InvoiceModel.fromEntity(Invoice invoice) {
    return InvoiceModel(
      id: invoice.id,
      invoiceNumber: invoice.invoiceNumber,
      businessId: invoice.businessId,
      customerId: invoice.customerId,
      customer: invoice.customer,
      orders: invoice.orders,
      subtotal: invoice.subtotal,
      vatRate: invoice.vatRate,
      vatAmount: invoice.vatAmount,
      nhilRate: invoice.nhilRate,
      nhilAmount: invoice.nhilAmount,
      getfundRate: invoice.getfundRate,
      getfundAmount: invoice.getfundAmount,
      totalTax: invoice.totalTax,
      totalAmount: invoice.totalAmount,
      amountPaid: invoice.amountPaid,
      status: invoice.status,
      paymentMethod: invoice.paymentMethod,
      paymentDate: invoice.paymentDate,
      issueDate: invoice.issueDate,
      dueDate: invoice.dueDate,
      notes: invoice.notes,
      createdAt: invoice.createdAt,
      updatedAt: invoice.updatedAt,
    );
  }

  factory InvoiceModel.fromMap(Map<String, dynamic> map) {
    return InvoiceModel(
      id: map['id'] ?? '',
      invoiceNumber: map['invoiceNumber'] ?? '',
      businessId: map['businessId'] ?? '',
      customerId: map['customerId'] ?? '',
      customer: map['customer'] != null
          ? CustomerModel.fromMap(map['customer'])
          : null,
      orders: map['orders'] != null
          ? (map['orders'] as List)
                .map((order) => OrderModel.fromMap(order))
                .toList()
          : null,
      subtotal: (map['subtotal'] is String)
          ? double.parse(map['subtotal'])
          : (map['subtotal'] ?? 0.0).toDouble(),
      vatRate: (map['vatRate'] is String)
          ? double.parse(map['vatRate'])
          : (map['vatRate'] ?? 0.15).toDouble(),
      vatAmount: (map['vatAmount'] is String)
          ? double.parse(map['vatAmount'])
          : (map['vatAmount'] ?? 0.0).toDouble(),
      nhilRate: (map['nhilRate'] is String)
          ? double.parse(map['nhilRate'])
          : (map['nhilRate'] ?? 0.025).toDouble(),
      nhilAmount: (map['nhilAmount'] is String)
          ? double.parse(map['nhilAmount'])
          : (map['nhilAmount'] ?? 0.0).toDouble(),
      getfundRate: (map['getfundRate'] is String)
          ? double.parse(map['getfundRate'])
          : (map['getfundRate'] ?? 0.025).toDouble(),
      getfundAmount: (map['getfundAmount'] is String)
          ? double.parse(map['getfundAmount'])
          : (map['getfundAmount'] ?? 0.0).toDouble(),
      totalTax: (map['totalTax'] is String)
          ? double.parse(map['totalTax'])
          : (map['totalTax'] ?? 0.0).toDouble(),
      totalAmount: (map['totalAmount'] is String)
          ? double.parse(map['totalAmount'])
          : (map['totalAmount'] ?? 0.0).toDouble(),
      amountPaid: (map['amountPaid'] is String)
          ? double.parse(map['amountPaid'])
          : (map['amountPaid'] ?? 0.0).toDouble(),
      status: InvoiceStatus.fromJson(map['status'] ?? 'DRAFT'),
      paymentMethod: map['paymentMethod'] != null
          ? PaymentMethod.fromJson(map['paymentMethod'])
          : null,
      paymentDate: map['paymentDate'] != null
          ? DateTime.parse(map['paymentDate'])
          : null,
      issueDate: map['issueDate'] != null
          ? DateTime.parse(map['issueDate'])
          : null,
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      notes: map['notes'],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoiceNumber': invoiceNumber,
      'businessId': businessId,
      'customerId': customerId,
      'customer': customer != null
          ? CustomerModel.fromEntity(customer!).toJson()
          : null,
      'orders': orders
          ?.map((order) => OrderModel.fromEntity(order).toJson())
          .toList(),
      'subtotal': subtotal,
      'vatRate': vatRate,
      'vatAmount': vatAmount,
      'nhilRate': nhilRate,
      'nhilAmount': nhilAmount,
      'getfundRate': getfundRate,
      'getfundAmount': getfundAmount,
      'totalTax': totalTax,
      'totalAmount': totalAmount,
      'amountPaid': amountPaid,
      'status': status.toJson(),
      'paymentMethod': paymentMethod?.toJson(),
      'paymentDate': paymentDate?.toIso8601String(),
      'issueDate': issueDate?.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'invoiceNumber': invoiceNumber,
      'businessId': businessId,
      'customerId': customerId,
      'customer': customer != null
          ? CustomerModel.fromEntity(customer!).toMap()
          : null,
      'orders': orders
          ?.map((order) => OrderModel.fromEntity(order).toMap())
          .toList(),
      'subtotal': subtotal,
      'vatRate': vatRate,
      'vatAmount': vatAmount,
      'nhilRate': nhilRate,
      'nhilAmount': nhilAmount,
      'getfundRate': getfundRate,
      'getfundAmount': getfundAmount,
      'totalTax': totalTax,
      'totalAmount': totalAmount,
      'amountPaid': amountPaid,
      'status': status.toJson(),
      'paymentMethod': paymentMethod?.toJson(),
      'paymentDate': paymentDate?.toIso8601String(),
      'issueDate': issueDate?.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Invoice toEntity() {
    return Invoice(
      id: id,
      invoiceNumber: invoiceNumber,
      businessId: businessId,
      customerId: customerId,
      customer: customer,
      orders: orders,
      subtotal: subtotal,
      vatRate: vatRate,
      vatAmount: vatAmount,
      nhilRate: nhilRate,
      nhilAmount: nhilAmount,
      getfundRate: getfundRate,
      getfundAmount: getfundAmount,
      totalTax: totalTax,
      totalAmount: totalAmount,
      amountPaid: amountPaid,
      status: status,
      paymentMethod: paymentMethod,
      paymentDate: paymentDate,
      issueDate: issueDate,
      dueDate: dueDate,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
