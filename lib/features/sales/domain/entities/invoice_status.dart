enum InvoiceStatus {
  draft,
  sent,
  paid,
  partiallyPaid,
  overdue,
  cancelled;

  String toJson() {
    switch (this) {
      case InvoiceStatus.draft:
        return 'DRAFT';
      case InvoiceStatus.sent:
        return 'SENT';
      case InvoiceStatus.paid:
        return 'PAID';
      case InvoiceStatus.partiallyPaid:
        return 'PARTIALLY_PAID';
      case InvoiceStatus.overdue:
        return 'OVERDUE';
      case InvoiceStatus.cancelled:
        return 'CANCELLED';
    }
  }

  static InvoiceStatus fromJson(String json) {
    switch (json.toUpperCase()) {
      case 'DRAFT':
        return InvoiceStatus.draft;
      case 'SENT':
        return InvoiceStatus.sent;
      case 'PAID':
        return InvoiceStatus.paid;
      case 'PARTIALLY_PAID':
        return InvoiceStatus.partiallyPaid;
      case 'OVERDUE':
        return InvoiceStatus.overdue;
      case 'CANCELLED':
        return InvoiceStatus.cancelled;
      default:
        return InvoiceStatus.draft;
    }
  }
}
