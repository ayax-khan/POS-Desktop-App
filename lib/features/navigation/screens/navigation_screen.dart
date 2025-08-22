import 'package:flutter/material.dart';
import 'package:pos/core/constraints/colors.dart';
import 'package:pos/core/constraints/spacing.dart';
import '../../home/screens/home_screen.dart';
import '../../Products/Screens/products_screen.dart';
import '../../customer/screens/customer_screen.dart';
import '../../invoice/screens/invoice_screen.dart';
import '../../reports/screens/reports_screen.dart';
import '../../settings/screens/settings_screen.dart';
import '../widgets/app_bar_first_row.dart';
import '../widgets/app_bar_second_row.dart';

class NavigationItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String key;

  NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.key,
  });
}

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;
  Widget _currentScreen = const HomeScreen();

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      label: 'Home',
      key: 'Home',
    ),
    NavigationItem(
      icon: Icons.inventory_2_outlined,
      selectedIcon: Icons.inventory_2,
      label: 'Products',
      key: 'Products',
    ),
    NavigationItem(
      icon: Icons.people_outline,
      selectedIcon: Icons.people,
      label: 'Customers',
      key: 'Customer',
    ),
    NavigationItem(
      icon: Icons.receipt_long_outlined,
      selectedIcon: Icons.receipt_long,
      label: 'Invoices',
      key: 'Invoice',
    ),
    NavigationItem(
      icon: Icons.analytics_outlined,
      selectedIcon: Icons.analytics,
      label: 'Reports',
      key: 'Reports',
    ),
    NavigationItem(
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      label: 'Settings',
      key: 'Settings',
    ),
  ];

  void _selectFeature(String feature) {
    setState(() {
      final index = _navigationItems.indexWhere((item) => item.key == feature);
      if (index != -1) {
        _selectedIndex = index;
      }
      switch (feature) {
        case 'Home':
          _currentScreen = const HomeScreen();
          break;
        case 'Products':
          _currentScreen = const ProductsScreen();
          break;
        case 'Customer':
          _currentScreen = const CustomerScreen();
          break;
        case 'Invoice':
          _currentScreen = const InvoiceScreen();
          break;
        case 'Reports':
          _currentScreen = const ReportsScreen();
          break;
        case 'Settings':
          _currentScreen = const SettingsScreen();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppBarFirstRow(),
            SizedBox(height: AppSpacing.medium(context)),
            const AppBarSecondRow(),
          ],
        ),
      ),
      body: Row(
        children: [
          // Styled Sidebar
          Container(
            width: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                // Logo/Header
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.point_of_sale,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'POS System',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Desktop Edition',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Navigation Items
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _navigationItems.length,
                    itemBuilder: (context, index) {
                      final item = _navigationItems[index];
                      final isSelected = _selectedIndex == index;

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 2,
                        ),
                        child: Material(
                          color:
                              isSelected
                                  ? Colors.blue.withOpacity(0.1)
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            onTap: () => _selectFeature(item.key),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isSelected ? item.selectedIcon : item.icon,
                                    color:
                                        isSelected
                                            ? Colors.blue
                                            : Colors.grey.shade600,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    item.label,
                                    style: TextStyle(
                                      color:
                                          isSelected
                                              ? Colors.blue
                                              : Colors.grey.shade700,
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Main Content Area
          Expanded(
            child: Container(
              color: AppColors.background,
              child: _currentScreen,
            ),
          ),
        ],
      ),
    );
  }
}
