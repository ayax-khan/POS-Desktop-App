import 'package:flutter/material.dart';
import 'package:pos/features/Reports/Models/revenue_data.dart';

abstract class BaseChart extends StatelessWidget {
  final List<ChartDataPoint> revenueData;
  final List<ChartDataPoint> visitorsData;
  final List<ChartDataPoint> productsData;
  final Set<String> selectedMetrics;
  final String? period;

  const BaseChart({
    super.key,
    required this.revenueData,
    required this.visitorsData,
    required this.productsData,
    required this.selectedMetrics,
    this.period,
  });

  @protected
  bool get hasData {
    return revenueData.isNotEmpty ||
        visitorsData.isNotEmpty ||
        productsData.isNotEmpty;
  }

  @protected
  Widget buildNoDataWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics_outlined, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No data available for this period',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
