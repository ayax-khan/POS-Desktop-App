import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:pos/features/Reports/Models/revenue_data.dart';
import 'base_chart.dart';

class RevenuePieChart extends BaseChart {
  const RevenuePieChart({
    super.key,
    required super.revenueData,
    required super.visitorsData,
    required super.productsData,
    required super.selectedMetrics,
    super.period,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasData) return buildNoDataWidget(context);

    return SfCircularChart(
      title: ChartTitle(text: 'Distribution Analysis - Pie Chart'),
      legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CircularSeries>[
        PieSeries<ChartDataPoint, String>(
          dataSource: _getPieChartData(),
          xValueMapper: (ChartDataPoint data, _) => _getLabel(data),
          yValueMapper: (ChartDataPoint data, _) => data.value,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          enableTooltip: true,
        ),
      ],
    );
  }

  List<ChartDataPoint> _getPieChartData() {
    final List<ChartDataPoint> pieData = [];

    // For pie chart, we show cumulative data
    if (selectedMetrics.contains('Revenue') && revenueData.isNotEmpty) {
      final totalRevenue = revenueData
          .map((e) => e.value)
          .reduce((a, b) => a + b);
      pieData.add(
        ChartDataPoint(
          date: DateTime.now(),
          value: totalRevenue,
          label: 'Revenue',
        ),
      );
    }

    if (selectedMetrics.contains('Customers') && visitorsData.isNotEmpty) {
      final totalCustomers = visitorsData
          .map((e) => e.value)
          .reduce((a, b) => a + b);
      pieData.add(
        ChartDataPoint(
          date: DateTime.now(),
          value: totalCustomers,
          label: 'Customers',
        ),
      );
    }

    if (selectedMetrics.contains('Products') && productsData.isNotEmpty) {
      final totalProducts = productsData
          .map((e) => e.value)
          .reduce((a, b) => a + b);
      pieData.add(
        ChartDataPoint(
          date: DateTime.now(),
          value: totalProducts,
          label: 'Products',
        ),
      );
    }

    return pieData;
  }

  String _getLabel(ChartDataPoint data) {
    return data.label ?? 'Unknown';
  }
}
