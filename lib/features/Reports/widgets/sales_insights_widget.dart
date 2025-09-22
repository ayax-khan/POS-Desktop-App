// lib/features/Reports/Widgets/sales_insights_widget.dart
import 'package:flutter/material.dart';
import 'package:pos/core/constraints/colors.dart';
import 'package:pos/core/constraints/fonts.dart';
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
    return Container(
      padding: EdgeInsets.all(AppSpacing.medium(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: AppSpacing.medium(context)),
          _buildInsightsList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(Icons.lightbulb_outline, color: Colors.amber.shade600, size: 24),
        SizedBox(width: AppSpacing.small(null)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sales Insights',
              style: AppFonts.heading.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Key performance indicators',
              style: AppFonts.bodyText.copyWith(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInsightsList() {
    return Column(
      children: [
        _buildInsightItem(
          icon: Icons.calendar_today,
          title: 'Best Sales Day',
          value: bestSalesDay,
          color: Colors.green,
        ),
        SizedBox(height: AppSpacing.medium(null)),
        _buildInsightItem(
          icon: Icons.schedule,
          title: 'Peak Sales Hour',
          value: peakSaleHour,
          subtitle: 'PKR ${peakSaleAmount.toStringAsFixed(0)} revenue',
          color: Colors.blue,
        ),
        SizedBox(height: AppSpacing.medium(null)),
        _buildInsightItem(
          icon: Icons.warning_outlined,
          title: 'Low Stock Items',
          value: lowStockCount.toString(),
          subtitle: 'Items need restocking',
          color: lowStockCount > 0 ? Colors.red : Colors.grey,
          showAction: lowStockCount > 0,
        ),
      ],
    );
  }

  Widget _buildInsightItem({
    required IconData icon,
    required String title,
    required String value,
    String? subtitle,
    required Color color,
    bool showAction = false,
  }) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.medium(null)),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(width: AppSpacing.medium(null)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppFonts.bodyText.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: AppFonts.bodyText.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppFonts.bodyText.copyWith(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (showAction)
            TextButton(
              onPressed: () {
                // TODO: Navigate to inventory management
              },
              style: TextButton.styleFrom(
                backgroundColor: color.withOpacity(0.1),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
              ),
              child: Text(
                'Reorder',
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
