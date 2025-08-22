// lib/features/Reports/Widgets/metric_card.dart
import 'package:flutter/material.dart';
import 'package:pos/core/constraints/fonts.dart';
import 'package:pos/core/constraints/spacing.dart';

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final double previousDayChange;
  final double weekOverWeekChange;
  final bool showCheckIcon;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.previousDayChange,
    required this.weekOverWeekChange,
    required this.showCheckIcon,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppFonts.bodyText.copyWith(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (showCheckIcon)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 16),
                ),
            ],
          ),
          SizedBox(height: AppSpacing.small(context)),
          Text(
            value,
            style: AppFonts.appBarTitle.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSpacing.small(context)),
          Row(
            children: [
              _buildChangeIndicator(
                'vs Previous Day',
                previousDayChange,
                Colors.teal,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.extraSmall(context)),
          Row(
            children: [
              _buildChangeIndicator(
                'Week over Week',
                weekOverWeekChange,
                Colors.teal,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChangeIndicator(String label, double change, Color color) {
    final isPositive = change >= 0;
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                color: color,
                size: 12,
              ),
              const SizedBox(width: 2),
              Text(
                '${change.abs().toStringAsFixed(2)}%',
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
