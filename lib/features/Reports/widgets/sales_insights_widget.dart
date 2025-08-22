// lib/features/Reports/Widgets/sales_insights_widget.dart
import 'package:flutter/material.dart';
import 'package:pos/core/constraints/spacing.dart';

class SalesInsightsWidget extends StatelessWidget {
  final String bestSalesDay;
  final String peakSaleHour;
  final double peakSaleAmount;
  final int lowStockCount;

  const SalesInsightsWidget({
    super.key,
    required this.bestSalesDay,
    required this.peakSaleHour,
    required this.peakSaleAmount,
    required this.lowStockCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildInsightCard(
            'Best Sales Day',
            bestSalesDay,
            Icons.local_fire_department,
            Colors.red,
          ),
        ),
        SizedBox(width: AppSpacing.medium(context)),
        Expanded(
          child: _buildInsightCard(
            'Peak Sale Hour',
            '$peakSaleHour\nPKR ${peakSaleAmount.toStringAsFixed(0)}',
            Icons.access_time,
            Colors.blue,
          ),
        ),
        SizedBox(width: AppSpacing.medium(context)),
        Expanded(
          child: _buildInsightCard(
            'Low Stock',
            '$lowStockCount units',
            Icons.inventory_2,
            Colors.orange,
            actionText: 'Reorder',
          ),
        ),
      ],
    );
  }

  Widget _buildInsightCard(
    String title,
    String value,
    IconData icon,
    Color color, {
    String? actionText,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          if (actionText != null) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                // Handle action
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                actionText,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
