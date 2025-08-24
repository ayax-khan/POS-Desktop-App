// lib/features/Home/widgets/quick_actions_widget.dart
import 'package:animated_icon/animated_icon.dart';
import 'package:flutter/material.dart';

class QuickActionsWidget extends StatelessWidget {
  final VoidCallback onNewSale;
  final VoidCallback onAddProduct;
  final VoidCallback onViewReports;
  final VoidCallback onManageCustomers;

  const QuickActionsWidget({
    super.key,
    required this.onNewSale,
    required this.onAddProduct,
    required this.onViewReports,
    required this.onManageCustomers,
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
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  animateIcon: AnimateIcons.file,
                  gifPath: "assets/icons/sale.gif",
                  label: 'New Sale',
                  onTap: onNewSale,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  animateIcon: AnimateIcons.calculator,
                  gifPath: "assets/icons/add_prod.gif",
                  label: 'Add Product',
                  onTap: onAddProduct,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  animateIcon: AnimateIcons.list,
                  gifPath: "assets/icons/reports.gif",
                  label: 'View Reports',
                  onTap: onViewReports,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  animateIcon: AnimateIcons.confused,
                  gifPath: "assets/icons/customers.gif",
                  label: 'Customers',
                  onTap: onManageCustomers,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Ab ye button ya to GIF show karega ya AnimatedIcon
  Widget _buildActionButton({
    AnimateIcons? animateIcon,
    String? gifPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              if (gifPath != null)
                Image.asset(gifPath, height: 40, width: 40, fit: BoxFit.cover)
              else if (animateIcon != null)
                AnimateIcon(
                  onTap: onTap,
                  iconType: IconType.continueAnimation,
                  height: 30,
                  width: 30,
                  color: Colors.white,
                  animateIcon: animateIcon,
                ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
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
