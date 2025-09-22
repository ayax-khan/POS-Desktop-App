// lib/features/Reports/Widgets/hourly_revenue_widget.dart
import 'package:flutter/material.dart';
import 'package:pos/core/constraints/colors.dart';
import 'package:pos/core/constraints/fonts.dart';
import 'package:pos/core/constraints/spacing.dart';
import 'package:pos/features/Reports/Models/revenue_data.dart';

class HourlyRevenueWidget extends StatelessWidget {
  final List<HourlyRevenue> hourlyData;
  final String? period;

  const HourlyRevenueWidget({super.key, required this.hourlyData, this.period});

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
          _buildHeader(),
          SizedBox(height: AppSpacing.medium(context)),
          _buildHourlyList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    String title = 'Hourly Revenue';
    String subtitle = 'Revenue breakdown by hour';

    if (period == 'Last Month') {
      title = 'Weekly Revenue';
      subtitle = 'Revenue breakdown by week';
    } else if (period == 'Last Week') {
      title = 'Daily Revenue';
      subtitle = 'Revenue breakdown by day';
    }

    return Row(
      children: [
        Icon(Icons.access_time_outlined, color: Colors.purple, size: 24),
        SizedBox(width: AppSpacing.small(null)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppFonts.heading.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: AppFonts.bodyText.copyWith(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHourlyList() {
    if (hourlyData.isEmpty) {
      return Container(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.access_time_outlined,
                size: 48,
                color: Colors.grey.shade400,
              ),
              SizedBox(height: AppSpacing.small(null)),
              Text(
                'No hourly data available',
                style: AppFonts.bodyText.copyWith(
                  color: Colors.grey.shade500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Find max value for bar chart scaling
    final maxValue =
        hourlyData.isEmpty
            ? 1.0
            : hourlyData.map((e) => e.amount).reduce((a, b) => a > b ? a : b);

    return Column(
      children:
          hourlyData.map((hour) => _buildHourlyItem(hour, maxValue)).toList(),
    );
  }

  Widget _buildHourlyItem(HourlyRevenue hour, double maxValue) {
    final percentage = maxValue > 0 ? hour.amount / maxValue : 0.0;

    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.small(null)),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              hour.hour,
              style: AppFonts.bodyText.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.small(null)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade200,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        height: 24,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey.shade200,
                        ),
                      ),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 800),
                            height: 24,
                            width: percentage * constraints.maxWidth * 0.3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.purple.shade400,
                                  Colors.purple.shade600,
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'PKR ${hour.amount.toStringAsFixed(0)}',
                  style: AppFonts.bodyText.copyWith(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.small(null)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${(percentage * 100).toInt()}%',
              style: TextStyle(
                color: Colors.purple.shade700,
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
