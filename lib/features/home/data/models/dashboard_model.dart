import 'package:ventura/features/home/domain/entities/dashboard_entity.dart';

class DashboardDataModel extends DashboardData {
  DashboardDataModel({
    required super.financial,
    required super.stats,
    required super.alerts,
    required super.topPerformers,
    required super.recentActivity,
    required super.cancellations,
  });

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) {
    return DashboardDataModel(
      financial: FinancialModel.fromJson(json['financial'] ?? {}),
      stats: StatsModel.fromJson(json['stats'] ?? {}),
      alerts: AlertsModel.fromJson(json['alerts'] ?? {}),
      topPerformers: TopPerformersModel.fromJson(json['topPerformers'] ?? {}),
      recentActivity:
          (json['recentActivity'] as List?)
              ?.map((e) => RecentActivityModel.fromJson(e))
              .toList() ??
          [],
      cancellations: CancellationsModel.fromJson(json['cancellations'] ?? {}),
    );
  }
}

class FinancialModel extends Financial {
  FinancialModel({
    required super.totalRevenue,
    required super.netRevenue,
    required super.totalTax,
    required super.unpaidInvoices,
  });

  factory FinancialModel.fromJson(Map<String, dynamic> json) {
    return FinancialModel(
      totalRevenue: TotalRevenueModel.fromJson(json['totalRevenue'] ?? {}),
      netRevenue: NetRevenueModel.fromJson(json['netRevenue'] ?? {}),
      totalTax: TotalTaxModel.fromJson(json['totalTax'] ?? {}),
      unpaidInvoices: UnpaidInvoicesModel.fromJson(
        json['unpaidInvoices'] ?? {},
      ),
    );
  }
}

class TotalRevenueModel extends TotalRevenue {
  TotalRevenueModel({required super.amount, required super.trend});

  factory TotalRevenueModel.fromJson(Map<String, dynamic> json) {
    return TotalRevenueModel(
      amount: (json['amount'] ?? 0.0).toDouble(),
      trend: TrendModel.fromJson(json['trend'] ?? {}),
    );
  }
}

class TrendModel extends Trend {
  TrendModel({required super.percentage, required super.direction});

  factory TrendModel.fromJson(Map<String, dynamic> json) {
    return TrendModel(
      percentage: (json['percentage'] ?? 0.0).toDouble(),
      direction: json['direction'] ?? 'up',
    );
  }
}

class NetRevenueModel extends NetRevenue {
  NetRevenueModel({required super.amount, required super.afterTaxes});

  factory NetRevenueModel.fromJson(Map<String, dynamic> json) {
    return NetRevenueModel(
      amount: (json['amount'] ?? 0.0).toDouble(),
      afterTaxes: json['afterTaxes'] ?? true,
    );
  }
}

class TotalTaxModel extends TotalTax {
  TotalTaxModel({required super.amount, required super.breakdown});

  factory TotalTaxModel.fromJson(Map<String, dynamic> json) {
    return TotalTaxModel(
      amount: (json['amount'] ?? 0.0).toDouble(),
      breakdown: TaxBreakdownModel.fromJson(json['breakdown'] ?? {}),
    );
  }
}

class TaxBreakdownModel extends TaxBreakdown {
  TaxBreakdownModel({
    required super.vat,
    required super.nhil,
    required super.getfund,
  });

  factory TaxBreakdownModel.fromJson(Map<String, dynamic> json) {
    return TaxBreakdownModel(
      vat: TaxItemModel.fromJson(json['vat'] ?? {}),
      nhil: TaxItemModel.fromJson(json['nhil'] ?? {}),
      getfund: TaxItemModel.fromJson(json['getfund'] ?? {}),
    );
  }
}

class TaxItemModel extends TaxItem {
  TaxItemModel({required super.rate, required super.amount});

  factory TaxItemModel.fromJson(Map<String, dynamic> json) {
    return TaxItemModel(
      rate: (json['rate'] ?? 0.0).toDouble(),
      amount: (json['amount'] ?? 0.0).toDouble(),
    );
  }
}

class UnpaidInvoicesModel extends UnpaidInvoices {
  UnpaidInvoicesModel({required super.amount, required super.count});

  factory UnpaidInvoicesModel.fromJson(Map<String, dynamic> json) {
    return UnpaidInvoicesModel(
      amount: (json['amount'] ?? 0.0).toDouble(),
      count: json['count'] ?? 0,
    );
  }
}

class StatsModel extends Stats {
  StatsModel({
    required super.totalOrders,
    required super.totalCustomers,
    required super.totalProducts,
    required super.totalInvoices,
  });

  factory StatsModel.fromJson(Map<String, dynamic> json) {
    return StatsModel(
      totalOrders: json['totalOrders'] ?? 0,
      totalCustomers: json['totalCustomers'] ?? 0,
      totalProducts: json['totalProducts'] ?? 0,
      totalInvoices: json['totalInvoices'] ?? 0,
    );
  }
}

class AlertsModel extends Alerts {
  AlertsModel({
    required super.pendingOrders,
    required super.outOfStockProducts,
    required super.overdueInvoices,
  });

  factory AlertsModel.fromJson(Map<String, dynamic> json) {
    return AlertsModel(
      pendingOrders: AlertItemsModel.fromJson(json['pendingOrders'] ?? {}),
      outOfStockProducts: AlertItemsModel.fromJson(
        json['outOfStockProducts'] ?? {},
      ),
      overdueInvoices: AlertItemsModel.fromJson(json['overdueInvoices'] ?? {}),
    );
  }
}

class AlertItemsModel extends AlertItems {
  AlertItemsModel({required super.count});

  factory AlertItemsModel.fromJson(Map<String, dynamic> json) {
    return AlertItemsModel(count: json['count'] ?? 0);
  }
}

class TopPerformersModel extends TopPerformers {
  TopPerformersModel({
    required super.topSellingProducts,
    required super.topCustomers,
  });

  factory TopPerformersModel.fromJson(Map<String, dynamic> json) {
    return TopPerformersModel(
      topSellingProducts:
          (json['topSellingProducts'] as List?)
              ?.map((e) => TopProductModel.fromJson(e))
              .toList() ??
          [],
      topCustomers:
          (json['topCustomers'] as List?)
              ?.map((e) => TopCustomerModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class TopProductModel extends TopProduct {
  TopProductModel({
    required super.id,
    required super.name,
    super.primaryImage,
    required super.totalRevenue,
    required super.totalQuantitySold,
    required super.totalOrders,
  });

  factory TopProductModel.fromJson(Map<String, dynamic> json) {
    return TopProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      primaryImage: json['primaryImage'],
      totalRevenue: (json['totalRevenue'] ?? 0.0).toDouble(),
      totalQuantitySold: json['totalQuantitySold'] ?? 0,
      totalOrders: json['totalOrders'] ?? 0,
    );
  }
}

class TopCustomerModel extends TopCustomer {
  TopCustomerModel({
    required super.id,
    required super.name,
    super.email,
    super.phone,
    required super.totalRevenue,
    required super.totalOrders,
    required super.averageOrderValue,
    required super.lastOrderDate,
  });

  factory TopCustomerModel.fromJson(Map<String, dynamic> json) {
    return TopCustomerModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'],
      phone: json['phone'],
      totalRevenue: (json['totalRevenue'] ?? 0.0).toDouble(),
      totalOrders: json['totalOrders'] ?? 0,
      averageOrderValue: (json['averageOrderValue'] ?? 0.0).toDouble(),
      lastOrderDate: json['lastOrderDate'] != null
          ? DateTime.parse(json['lastOrderDate'])
          : DateTime.now(),
    );
  }
}

class RecentActivityModel extends RecentActivity {
  RecentActivityModel({
    required super.id,
    required super.type,
    required super.title,
    required super.description,
    required super.metadata,
    required super.timestamp,
  });

  factory RecentActivityModel.fromJson(Map<String, dynamic> json) {
    return RecentActivityModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      metadata: json['metadata'] ?? {},
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }
}

class CancellationsModel extends Cancellations {
  CancellationsModel({
    required super.cancelledOrders,
    required super.cancelledInvoices,
  });

  factory CancellationsModel.fromJson(Map<String, dynamic> json) {
    return CancellationsModel(
      cancelledOrders: CancelledOrdersModel.fromJson(
        json['cancelledOrders'] ?? {},
      ),
      cancelledInvoices: CancelledInvoicesModel.fromJson(
        json['cancelledInvoices'] ?? {},
      ),
    );
  }
}

class CancelledOrdersModel extends CancelledOrders {
  CancelledOrdersModel({required super.total, required super.totalRevenueLost});

  factory CancelledOrdersModel.fromJson(Map<String, dynamic> json) {
    return CancelledOrdersModel(
      total: json['total'] ?? 0,
      totalRevenueLost: (json['totalRevenueLost'] ?? 0.0).toDouble(),
    );
  }
}

class CancelledInvoicesModel extends CancelledInvoices {
  CancelledInvoicesModel({
    required super.total,
    required super.totalRevenueLost,
  });

  factory CancelledInvoicesModel.fromJson(Map<String, dynamic> json) {
    return CancelledInvoicesModel(
      total: json['total'] ?? 0,
      totalRevenueLost: (json['totalRevenueLost'] ?? 0.0).toDouble(),
    );
  }
}
