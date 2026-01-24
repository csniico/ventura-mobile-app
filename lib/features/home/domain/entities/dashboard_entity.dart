class DashboardData {
  final Financial financial;
  final Stats stats;
  final Alerts alerts;
  final TopPerformers topPerformers;
  final List<RecentActivity> recentActivity;
  final Cancellations cancellations;

  DashboardData({
    required this.financial,
    required this.stats,
    required this.alerts,
    required this.topPerformers,
    required this.recentActivity,
    required this.cancellations,
  });
}

class Financial {
  final TotalRevenue totalRevenue;
  final NetRevenue netRevenue;
  final TotalTax totalTax;
  final UnpaidInvoices unpaidInvoices;

  Financial({
    required this.totalRevenue,
    required this.netRevenue,
    required this.totalTax,
    required this.unpaidInvoices,
  });
}

class TotalRevenue {
  final double amount;
  final Trend trend;

  TotalRevenue({required this.amount, required this.trend});
}

class Trend {
  final double percentage;
  final String direction;

  Trend({required this.percentage, required this.direction});
}

class NetRevenue {
  final double amount;
  final bool afterTaxes;

  NetRevenue({required this.amount, required this.afterTaxes});
}

class TotalTax {
  final double amount;
  final TaxBreakdown breakdown;

  TotalTax({required this.amount, required this.breakdown});
}

class TaxBreakdown {
  final TaxItem vat;
  final TaxItem nhil;
  final TaxItem getfund;

  TaxBreakdown({required this.vat, required this.nhil, required this.getfund});
}

class TaxItem {
  final double rate;
  final double amount;

  TaxItem({required this.rate, required this.amount});
}

class UnpaidInvoices {
  final double amount;
  final int count;

  UnpaidInvoices({required this.amount, required this.count});
}

class Stats {
  final int totalOrders;
  final int totalCustomers;
  final int totalProducts;
  final int totalInvoices;

  Stats({
    required this.totalOrders,
    required this.totalCustomers,
    required this.totalProducts,
    required this.totalInvoices,
  });
}

class Alerts {
  final AlertItems pendingOrders;
  final AlertItems outOfStockProducts;
  final AlertItems overdueInvoices;

  Alerts({
    required this.pendingOrders,
    required this.outOfStockProducts,
    required this.overdueInvoices,
  });
}

class AlertItems {
  final int count;

  AlertItems({required this.count});
}

class TopPerformers {
  final List<TopProduct> topSellingProducts;
  final List<TopCustomer> topCustomers;

  TopPerformers({required this.topSellingProducts, required this.topCustomers});
}

class TopProduct {
  final String id;
  final String name;
  final String? primaryImage;
  final double totalRevenue;
  final int totalQuantitySold;
  final int totalOrders;

  TopProduct({
    required this.id,
    required this.name,
    this.primaryImage,
    required this.totalRevenue,
    required this.totalQuantitySold,
    required this.totalOrders,
  });
}

class TopCustomer {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final double totalRevenue;
  final int totalOrders;
  final double averageOrderValue;
  final DateTime lastOrderDate;

  TopCustomer({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    required this.totalRevenue,
    required this.totalOrders,
    required this.averageOrderValue,
    required this.lastOrderDate,
  });
}

class RecentActivity {
  final String id;
  final String type;
  final String title;
  final String description;
  final Map<String, dynamic> metadata;
  final DateTime timestamp;

  RecentActivity({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.metadata,
    required this.timestamp,
  });
}

class Cancellations {
  final CancelledOrders cancelledOrders;
  final CancelledInvoices cancelledInvoices;

  Cancellations({
    required this.cancelledOrders,
    required this.cancelledInvoices,
  });
}

class CancelledOrders {
  final int total;
  final double totalRevenueLost;

  CancelledOrders({required this.total, required this.totalRevenueLost});
}

class CancelledInvoices {
  final int total;
  final double totalRevenueLost;

  CancelledInvoices({required this.total, required this.totalRevenueLost});
}
