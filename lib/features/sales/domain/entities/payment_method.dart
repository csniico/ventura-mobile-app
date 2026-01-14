enum PaymentMethod {
  cash,
  mobileMoney,
  bankTransfer,
  card,
  cheque;

  String toJson() {
    switch (this) {
      case PaymentMethod.cash:
        return 'CASH';
      case PaymentMethod.mobileMoney:
        return 'MOBILE_MONEY';
      case PaymentMethod.bankTransfer:
        return 'BANK_TRANSFER';
      case PaymentMethod.card:
        return 'CARD';
      case PaymentMethod.cheque:
        return 'CHEQUE';
    }
  }

  static PaymentMethod fromJson(String json) {
    switch (json.toUpperCase()) {
      case 'CASH':
        return PaymentMethod.cash;
      case 'MOBILE_MONEY':
        return PaymentMethod.mobileMoney;
      case 'BANK_TRANSFER':
        return PaymentMethod.bankTransfer;
      case 'CARD':
        return PaymentMethod.card;
      case 'CHEQUE':
        return PaymentMethod.cheque;
      default:
        return PaymentMethod.cash;
    }
  }

  String get displayName {
    switch (this) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.mobileMoney:
        return 'Mobile Money';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethod.card:
        return 'Card';
      case PaymentMethod.cheque:
        return 'Cheque';
    }
  }
}
