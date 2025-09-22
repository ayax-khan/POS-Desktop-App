// lib/features/Reports/Widgets/metric_card.dart
import 'package:flutter/material.dart';
import 'package:pos/core/constraints/colors.dart';
import 'package:pos/core/constraints/fonts.dart';
import 'package:pos/core/constraints/spacing.dart';

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final double? previousDayChange;
  final double? weekOverWeekChange;
  final bool showCheckIcon;
  final String? vsLabel;
  final IconData? icon;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    this.previousDayChange,
    this.weekOverWeekChange,
    this.showCheckIcon = false,
    this.vsLabel,
    this.icon,
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.grey.shade600, size: 20),
                SizedBox(width: AppSpacing.small(context)),
              ],
              Expanded(
                child: Text(
                  title,
                  style: AppFonts.bodyText.copyWith(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (showCheckIcon)
                Icon(Icons.check_circle, color: Colors.green, size: 16),
            ],
          ),
          SizedBox(height: AppSpacing.small(context)),
          Text(
            value,
            style: AppFonts.heading.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          if (previousDayChange != null) ...[
            SizedBox(height: AppSpacing.small(context)),
            _buildChangeIndicator(
              previousDayChange!,
              vsLabel ?? 'vs Previous Period',
              context,
            ),
          ],
          if (weekOverWeekChange != null) ...[
            SizedBox(height: AppSpacing.extraSmall(context)),
            _buildChangeIndicator(
              weekOverWeekChange!,
              'vs Previous Week',
              context,
              isSecondary: true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChangeIndicator(
    double change,
    String label,
    BuildContext context, {
    bool isSecondary = false,
  }) {
    final isPositive = change > 0;
    final isNeutral = change == 0;

    Color changeColor;
    IconData changeIcon;

    if (isNeutral) {
      changeColor = Colors.grey.shade600;
      changeIcon = Icons.remove;
    } else if (isPositive) {
      changeColor = Colors.green;
      changeIcon = Icons.arrow_upward;
    } else {
      changeColor = Colors.red;
      changeIcon = Icons.arrow_downward;
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: changeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(changeIcon, size: 12, color: changeColor),
              const SizedBox(width: 2),
              Text(
                '${change.abs().toStringAsFixed(1)}%',
                style: TextStyle(
                  color: changeColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: isSecondary ? Colors.grey.shade500 : Colors.grey.shade600,
              fontSize: isSecondary ? 10 : 11,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
