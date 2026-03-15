enum InvoiceType {
  standard,
  proforma,
  receipt;

  String toJson() {
    switch (this) {
      case InvoiceType.standard:
        return 'STANDARD';
      case InvoiceType.proforma:
        return 'PROFORMA';
      case InvoiceType.receipt:
        return 'RECIEPT'; // DB enum has typo until migration runs
    }
  }

  static InvoiceType fromJson(String json) {
    switch (json.toUpperCase()) {
      case 'PROFORMA':
        return InvoiceType.proforma;
      case 'RECEIPT':
        return InvoiceType.receipt;
      case 'STANDARD':
      default:
        return InvoiceType.standard;
    }
  }

  String get displayName {
    switch (this) {
      case InvoiceType.standard:
        return 'Standard';
      case InvoiceType.proforma:
        return 'Proforma';
      case InvoiceType.receipt:
        return 'Receipt';
    }
  }
}
