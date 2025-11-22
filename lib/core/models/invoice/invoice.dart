class InvoiceItem {
  final String id;
  final String invoiceId;
  final String description;
  final double quantity;
  final double unitPrice;
  final double total;

  InvoiceItem({
    required this.id,
    required this.invoiceId,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });

  // -------- JSON --------
  factory InvoiceItem.fromJson(Map<String, dynamic> json) => InvoiceItem(
    id: json["id"],
    invoiceId: json["invoiceId"],
    description: json["description"],
    quantity: (json["quantity"] ?? 0).toDouble(),
    unitPrice: (json["unitPrice"] ?? 0).toDouble(),
    total: (json["total"] ?? 0).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "invoiceId": invoiceId,
    "description": description,
    "quantity": quantity,
    "unitPrice": unitPrice,
    "total": total,
  };

  // -------- SQLite --------
  factory InvoiceItem.fromMap(Map<String, dynamic> map) => InvoiceItem(
    id: map["id"],
    invoiceId: map["invoiceId"],
    description: map["description"],
    quantity: (map["quantity"] ?? 0).toDouble(),
    unitPrice: (map["unitPrice"] ?? 0).toDouble(),
    total: (map["total"] ?? 0).toDouble(),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "invoiceId": invoiceId,
    "description": description,
    "quantity": quantity,
    "unitPrice": unitPrice,
    "total": total,
  };
}

class Invoice {
  final String id;
  final String invoiceNumber;
  final String status;
  final String issueDate;
  final String dueDate;
  final double subtotal;
  final double tax;
  final double discount;
  final double total;
  final double amountPaid;
  final double amountDue;
  final String? notes;
  final String? terms;
  final String? paymentMethod;
  final String businessId;
  final String customerId;

  List<InvoiceItem>? items;

  Invoice({
    required this.id,
    required this.invoiceNumber,
    required this.status,
    required this.issueDate,
    required this.dueDate,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.total,
    required this.amountPaid,
    required this.amountDue,
    required this.businessId,
    required this.customerId,
    this.notes,
    this.terms,
    this.paymentMethod,
    this.items,
  });

  // -------- JSON --------
  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
    id: json["id"],
    invoiceNumber: json["invoiceNumber"],
    status: json["status"],
    issueDate: json["issueDate"],
    dueDate: json["dueDate"],
    subtotal: (json["subtotal"] ?? 0).toDouble(),
    tax: (json["tax"] ?? 0).toDouble(),
    discount: (json["discount"] ?? 0).toDouble(),
    total: (json["total"] ?? 0).toDouble(),
    amountPaid: (json["amountPaid"] ?? 0).toDouble(),
    amountDue: (json["amountDue"] ?? 0).toDouble(),
    notes: json["notes"],
    terms: json["terms"],
    paymentMethod: json["paymentMethod"],
    businessId: json["businessId"],
    customerId: json["customerId"],
    items: (json["items"] as List<dynamic>?)
        ?.map((e) => InvoiceItem.fromJson(e))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "invoiceNumber": invoiceNumber,
    "status": status,
    "issueDate": issueDate,
    "dueDate": dueDate,
    "subtotal": subtotal,
    "tax": tax,
    "discount": discount,
    "total": total,
    "amountPaid": amountPaid,
    "amountDue": amountDue,
    "notes": notes,
    "terms": terms,
    "paymentMethod": paymentMethod,
    "businessId": businessId,
    "customerId": customerId,
    "items": items?.map((e) => e.toJson()).toList(),
  };

  // -------- SQLite --------
  factory Invoice.fromMap(Map<String, dynamic> map) => Invoice(
    id: map["id"],
    invoiceNumber: map["invoiceNumber"],
    status: map["status"],
    issueDate: map["issueDate"],
    dueDate: map["dueDate"],
    subtotal: (map["subtotal"] ?? 0).toDouble(),
    tax: (map["tax"] ?? 0).toDouble(),
    discount: (map["discount"] ?? 0).toDouble(),
    total: (map["total"] ?? 0).toDouble(),
    amountPaid: (map["amountPaid"] ?? 0).toDouble(),
    amountDue: (map["amountDue"] ?? 0).toDouble(),
    notes: map["notes"],
    terms: map["terms"],
    paymentMethod: map["paymentMethod"],
    businessId: map["businessId"],
    customerId: map["customerId"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "invoiceNumber": invoiceNumber,
    "status": status,
    "issueDate": issueDate,
    "dueDate": dueDate,
    "subtotal": subtotal,
    "tax": tax,
    "discount": discount,
    "total": total,
    "amountPaid": amountPaid,
    "amountDue": amountDue,
    "notes": notes,
    "terms": terms,
    "paymentMethod": paymentMethod,
    "businessId": businessId,
    "customerId": customerId,
  };
}
