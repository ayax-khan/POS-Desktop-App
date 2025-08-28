import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pos/core/services/navigation_service.dart';
import 'package:pos/features/Home/Widgets/dashboard_card.dart';
import 'package:pos/features/Home/Widgets/sales_chart.dart';
import 'package:pos/features/Home/Widgets/recent_transactions_table.dart';
import 'package:pos/features/Home/Widgets/top_products_widget.dart';
import 'package:pos/features/Home/Widgets/quick_actions_widget.dart';
import 'package:pos/features/Home/Models/dashboard_data.dart';
import 'package:pos/features/Home/Services/dashboard_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DashboardService _dashboardService = DashboardService();
  final NavigationService _navigationService = NavigationService();
  late ScrollController _scrollController;
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _initFuture = _dashboardService.loadDashboardData(); // Initialize here
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: FutureBuilder<void>(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return ValueListenableBuilder<Box<DashboardData>>(
            valueListenable: Hive.box<DashboardData>('dashboard').listenable(),
            builder: (context, box, _) {
              final dashboardData = box.get('current') ?? DashboardData.empty();

              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    expandedHeight: 120,
                    floating: false,
                    pinned: true,
                    backgroundColor: Colors.white,
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      title: const Text(
                        'Dashboard',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.blue.shade50, Colors.white],
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.black87),
                        onPressed: () async {
                          await _dashboardService.refreshData();
                          setState(() {});
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.black87,
                        ),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(24),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        QuickActionsWidget(
                          onNewSale: () => _navigationService.navigateToNewSale(),
                          onAddProduct: () => _navigationService.navigateToAddProduct(),
                          onViewReports: () => _navigationService.navigateToViewReports(),
                          onManageCustomers: () => _navigationService.navigateToManageCustomers(),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: DashboardCard(
                                title: 'Total Sales',
                                value:
                                    '\$${dashboardData.totalSales.toStringAsFixed(2)}',
                                icon: Icons.attach_money,
                                color: Colors.green,
                                percentage: dashboardData.salesGrowth,
                                trend:
                                    dashboardData.salesGrowth >= 0
                                        ? 'up'
                                        : 'down',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: DashboardCard(
                                title: 'Total Orders',
                                value: dashboardData.totalOrders.toString(),
                                icon: Icons.shopping_cart_outlined,
                                color: Colors.blue,
                                percentage: dashboardData.ordersGrowth,
                                trend:
                                    dashboardData.ordersGrowth >= 0
                                        ? 'up'
                                        : 'down',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: DashboardCard(
                                title: 'Total Customers',
                                value: dashboardData.totalCustomers.toString(),
                                icon: Icons.people_outline,
                                color: Colors.orange,
                                percentage: dashboardData.customersGrowth,
                                trend:
                                    dashboardData.customersGrowth >= 0
                                        ? 'up'
                                        : 'down',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: DashboardCard(
                                title: 'Low Stock Items',
                                value: dashboardData.lowStockItems.toString(),
                                icon: Icons.inventory_2_outlined,
                                color: Colors.red,
                                percentage: 0,
                                trend: 'neutral',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: SalesChart(
                                dailySales: dashboardData.dailySales,
                                weeklySales: dashboardData.weeklySales,
                                monthlySales: dashboardData.monthlySales,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TopProductsWidget(
                                products: dashboardData.topProducts,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        RecentTransactionsTable(
                          transactions: dashboardData.recentTransactions,
                        ),
                      ]),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
