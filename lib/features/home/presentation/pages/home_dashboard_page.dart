import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:ventura/config/routes.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ventura/features/home/domain/entities/dashboard_entity.dart';
import 'package:ventura/features/home/presentation/bloc/dashboard_bloc.dart';
import 'package:ventura/features/home/presentation/pages/not_signed_in_page.dart';
import 'package:ventura/features/home/presentation/pages/out_of_stock_products_page.dart';
import 'package:ventura/features/home/presentation/pages/overdue_invoices_page.dart';
import 'package:ventura/features/home/presentation/pages/pending_orders_page.dart';
import 'package:ventura/init_dependencies.dart';

class HomeDashboardPage extends StatefulWidget {
  const HomeDashboardPage({super.key});

  @override
  State<HomeDashboardPage> createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends State<HomeDashboardPage> {
  final AppRoutes routes = AppRoutes.instance;
  final currencyFormat = NumberFormat.currency(
    symbol: 'GHC ',
    decimalDigits: 2,
  );
  late final DashboardBloc _dashboardBloc;

  @override
  void initState() {
    super.initState();
    _dashboardBloc = serviceLocator<DashboardBloc>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only load if we don't have data yet (initial state)
    if (_dashboardBloc.state is DashboardInitial) {
      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated) {
        final businessId = authState.user.business?.id;
        if (businessId != null) {
          _dashboardBloc.add(DashboardLoadEvent(businessId: businessId));
        }
      }
    }
  }

  @override
  void dispose() {
    _dashboardBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {},
      builder: (context, authState) {
        if (authState is Authenticated) {
          return BlocProvider.value(
            value: _dashboardBloc,
            child: BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, dashboardState) {
                if (dashboardState is DashboardLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (dashboardState is DashboardError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading dashboard',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          dashboardState.message,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _refreshDashboard(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final dashboard = dashboardState is DashboardLoaded
                    ? dashboardState.dashboard
                    : null;

                return RefreshIndicator(
                  onRefresh: _refreshDashboard,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // _buildWelcomeSection(authState),
                        // const SizedBox(height: 24),

                        // Financial Overview
                        _buildSectionHeader('Financial Overview'),
                        const SizedBox(height: 12),
                        _buildFinancialCards(dashboard),
                        const SizedBox(height: 24),

                        // Quick Stats
                        _buildSectionHeader('Quick Stats'),
                        const SizedBox(height: 12),
                        _buildQuickStatsGrid(dashboard),
                        const SizedBox(height: 24),

                        // Alerts & Warnings
                        _buildSectionHeader('Action Required'),
                        const SizedBox(height: 12),
                        _buildAlertCards(dashboard),
                        const SizedBox(height: 24),

                        // Top Performers
                        _buildSectionHeader('Top Performers'),
                        const SizedBox(height: 12),
                        _buildTopPerformers(dashboard),
                        const SizedBox(height: 24),

                        // Recent Activity
                        _buildSectionHeader('Recent Activity'),
                        const SizedBox(height: 12),
                        _buildRecentActivity(dashboard),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
        return const Center(child: NotSignedInPage());
      },
    );
  }

  Future<void> _refreshDashboard() async {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      final businessId = authState.user.business?.id;
      if (businessId != null) {
        _dashboardBloc.add(DashboardLoadEvent(businessId: businessId));
      }
    }
  }

  Widget _buildWelcomeSection(Authenticated state) {
    final businessName = state.user.business?.name ?? 'Your Business';
    final timeOfDay = _getGreeting();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$timeOfDay,',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          businessName,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildFinancialCards(DashboardData? dashboard) {
    final financial = dashboard?.financial;
    final totalRevenue = financial?.totalRevenue.amount ?? 0.0;
    final netRevenue = financial?.netRevenue.amount ?? 0.0;
    final totalTax = financial?.totalTax.amount ?? 0.0;
    final unpaidAmount = financial?.unpaidInvoices.amount ?? 0.0;
    final trend = financial?.totalRevenue.trend;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'Total Revenue',
                value: currencyFormat.format(totalRevenue),
                icon: HugeIcons.strokeRoundedMoneyBag02,
                color: Colors.green,
                trend: trend != null
                    ? '${trend.direction == 'up' ? '+' : '-'}${trend.percentage.toStringAsFixed(1)}%'
                    : null,
                isPositive: trend?.direction == 'up',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                title: 'Net Revenue',
                value: currencyFormat.format(netRevenue),
                subtitle: 'After Taxes',
                icon: HugeIcons.strokeRoundedDollar02,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'Total Taxes',
                value: currencyFormat.format(totalTax),
                subtitle: 'VAT + NHIL + GETFund',
                icon: HugeIcons.strokeRoundedTaxes,
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                title: 'Unpaid Invoices',
                value: currencyFormat.format(unpaidAmount),
                icon: HugeIcons.strokeRoundedInvoice,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickStatsGrid(DashboardData? dashboard) {
    final stats = dashboard?.stats;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          title: 'Total Orders',
          value: '${stats?.totalOrders ?? 0}',
          icon: HugeIcons.strokeRoundedShoppingCart01,
          color: Colors.purple,
        ),
        _buildStatCard(
          title: 'Total Customers',
          value: '${stats?.totalCustomers ?? 0}',
          icon: HugeIcons.strokeRoundedUserMultiple,
          color: Colors.teal,
        ),
        _buildStatCard(
          title: 'Total Products',
          value: '${stats?.totalProducts ?? 0}',
          icon: HugeIcons.strokeRoundedPackage,
          color: Colors.indigo,
        ),
        _buildStatCard(
          title: 'Total Invoices',
          value: '${stats?.totalInvoices ?? 0}',
          icon: HugeIcons.strokeRoundedInvoice01,
          color: Colors.cyan,
        ),
      ],
    );
  }

  Widget _buildAlertCards(DashboardData? dashboard) {
    final alerts = dashboard?.alerts;

    return Column(
      children: [
        _buildAlertCard(
          title: 'Pending Orders',
          count: alerts?.pendingOrders.count ?? 0,
          icon: HugeIcons.strokeRoundedClock01,
          color: Colors.orange,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PendingOrdersPage(),
              ),
            ).then((_) => _refreshDashboard());
          },
        ),
        const SizedBox(height: 8),
        _buildAlertCard(
          title: 'Out of Stock Products',
          count: alerts?.outOfStockProducts.count ?? 0,
          icon: HugeIcons.strokeRoundedAlertCircle,
          color: Colors.red,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OutOfStockProductsPage(),
              ),
            ).then((_) => _refreshDashboard());
          },
        ),
        const SizedBox(height: 8),
        _buildAlertCard(
          title: 'Overdue Invoices',
          count: alerts?.overdueInvoices.count ?? 0,
          icon: HugeIcons.strokeRoundedAlertDiamond,
          color: Colors.deepOrange,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OverdueInvoicesPage(),
              ),
            ).then((_) => _refreshDashboard());
          },
        ),
      ],
    );
  }

  Widget _buildTopPerformers(DashboardData? dashboard) {
    final topPerformers = dashboard?.topPerformers;

    return Column(
      children: [
        _buildPerformerCard(
          title: 'Top Selling Products',
          items: topPerformers?.topSellingProducts ?? [],
          emptyMessage: 'No sales data yet',
          isProduct: true,
        ),
        const SizedBox(height: 12),
        _buildPerformerCard(
          title: 'Top Customers',
          items: topPerformers?.topCustomers ?? [],
          emptyMessage: 'No customer data yet',
          isProduct: false,
        ),
      ],
    );
  }

  Widget _buildRecentActivity(DashboardData? dashboard) {
    return _buildActivityCard(
      activities: dashboard?.recentActivity ?? [],
      emptyMessage: 'No recent activity',
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    String? subtitle,
    required List<List<dynamic>> icon,
    required Color color,
    String? trend,
    bool? isPositive,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: HugeIcon(icon: icon, color: color, size: 20),
              ),
              const Spacer(),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: (isPositive ?? true)
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    trend,
                    style: TextStyle(
                      color: (isPositive ?? true) ? Colors.green : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required List<List<dynamic>> icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HugeIcon(icon: icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard({
    required String title,
    required int count,
    required List<List<dynamic>> icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: HugeIcon(icon: icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    count == 0 ? 'All clear' : '$count items need attention',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            HugeIcon(
              icon: HugeIcons.strokeRoundedArrowRight01,
              color: color,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformerCard({
    required String title,
    required List items,
    required String emptyMessage,
    required bool isProduct,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  emptyMessage,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ),
            )
          else
            ...items.take(5).map((item) {
              if (isProduct) {
                final product = item as TopProduct;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      if (product.primaryImage != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.primaryImage!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 40,
                              height: 40,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image, size: 20),
                            ),
                          ),
                        )
                      else
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.shopping_bag, size: 20),
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${product.totalQuantitySold} sold • ${product.totalOrders} orders',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.6),
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        currencyFormat.format(product.totalRevenue),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                final customer = item as TopCustomer;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blue.withOpacity(0.1),
                        child: Text(
                          customer.name.isNotEmpty
                              ? customer.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customer.name,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${customer.totalOrders} orders • Avg: ${currencyFormat.format(customer.averageOrderValue)}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.6),
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        currencyFormat.format(customer.totalRevenue),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                );
              }
            }),
        ],
      ),
    );
  }

  Widget _buildActivityCard({
    required List<RecentActivity> activities,
    required String emptyMessage,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (activities.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  emptyMessage,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ),
            )
          else
            ...activities.take(10).map((activity) {
              final icon = _getActivityIcon(activity.type);
              final color = _getActivityColor(activity.type);
              final timeAgo = _getTimeAgo(activity.timestamp);

              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: HugeIcon(icon: icon, color: color, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity.title,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            activity.description,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.6),
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            timeAgo,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.4),
                                  fontSize: 11,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  List<List<dynamic>> _getActivityIcon(String type) {
    switch (type.toLowerCase()) {
      case 'order_created':
        return HugeIcons.strokeRoundedShoppingCart01;
      case 'invoice_created':
        return HugeIcons.strokeRoundedInvoice;
      case 'invoice_paid':
        return HugeIcons.strokeRoundedCheckmarkCircle01;
      case 'customer_added':
        return HugeIcons.strokeRoundedUserAdd01;
      case 'product_added':
        return HugeIcons.strokeRoundedPackageAdd;
      case 'order_cancelled':
        return HugeIcons.strokeRoundedCancelCircle;
      case 'invoice_cancelled':
        return HugeIcons.strokeRoundedCancelSquare;
      default:
        return HugeIcons.strokeRoundedInformationCircle;
    }
  }

  Color _getActivityColor(String type) {
    switch (type.toLowerCase()) {
      case 'order_created':
        return Colors.purple;
      case 'invoice_created':
        return Colors.blue;
      case 'invoice_paid':
        return Colors.green;
      case 'customer_added':
        return Colors.teal;
      case 'product_added':
        return Colors.indigo;
      case 'order_cancelled':
      case 'invoice_cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }
}
