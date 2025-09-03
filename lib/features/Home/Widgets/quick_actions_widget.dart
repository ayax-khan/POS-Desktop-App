// lib/features/Home/widgets/quick_actions_widget.dart
import 'package:flutter/material.dart';

class QuickActionsWidget extends StatelessWidget {
  final VoidCallback onNewSale;
  final VoidCallback onAddProduct;
  final VoidCallback onViewReports;
  final VoidCallback onManageCustomers;
  final VoidCallback onViewReturns;

  const QuickActionsWidget({
    super.key,
    required this.onNewSale,
    required this.onAddProduct,
    required this.onViewReports,
    required this.onManageCustomers,
    required this.onViewReturns,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade600, Colors.blue.shade800],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // First row with 3 buttons
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.point_of_sale,
                  label: 'New Sale',
                  onTap: onNewSale,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.add_box_outlined,
                  label: 'Add Product',
                  onTap: onAddProduct,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.analytics_outlined,
                  label: 'View Reports',
                  onTap: onViewReports,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Second row with 2 buttons
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.people_outline,
                  label: 'Customers',
                  onTap: onManageCustomers,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.assignment_return,
                  label: 'Returns',
                  onTap: onViewReturns,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              // Empty space to balance the layout
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    final buttonColor = color ?? Colors.white;
    
    return Material(
      color: buttonColor.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: buttonColor, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: buttonColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
