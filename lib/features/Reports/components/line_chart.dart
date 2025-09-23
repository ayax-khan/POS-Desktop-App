import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:pos/features/Reports/Models/revenue_data.dart';
import 'base_chart.dart';

class RevenueLineChart extends BaseChart {
  const RevenueLineChart({
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

    return SfCartesianChart(
      title: ChartTitle(text: 'Trend Analysis - Line Chart'),
      legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      primaryXAxis: DateTimeAxis(
        title: AxisTitle(text: 'Date'),
        dateFormat: _getDateFormat(),
        intervalType: _getIntervalType(),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: 'Value'),
        numberFormat: NumberFormat.compact(),
      ),
      series: _getChartSeries(),
    );
  }

  List<LineSeries<ChartDataPoint, DateTime>> _getChartSeries() {
    final List<LineSeries<ChartDataPoint, DateTime>> series = [];

    if (selectedMetrics.contains('Revenue') && revenueData.isNotEmpty) {
      series.add(
        LineSeries<ChartDataPoint, DateTime>(
          name: 'Revenue',
          dataSource: revenueData,
          xValueMapper: (data, _) => data.date,
          yValueMapper: (data, _) => data.value,
          color: Colors.blue,
          width: 3,
          markerSettings: const MarkerSettings(isVisible: true),
        ),
      );
    }

    if (selectedMetrics.contains('Customers') && visitorsData.isNotEmpty) {
      series.add(
        LineSeries<ChartDataPoint, DateTime>(
          name: 'Customers',
          dataSource: visitorsData,
          xValueMapper: (data, _) => data.date,
          yValueMapper: (data, _) => data.value,
          color: Colors.orange,
          width: 3,
          markerSettings: const MarkerSettings(isVisible: true),
        ),
      );
    }

    if (selectedMetrics.contains('Products') && productsData.isNotEmpty) {
      series.add(
        LineSeries<ChartDataPoint, DateTime>(
          name: 'Products',
          dataSource: productsData,
          xValueMapper: (data, _) => data.date,
          yValueMapper: (data, _) => data.value,
          color: Colors.green,
          width: 3,
          markerSettings: const MarkerSettings(isVisible: true),
        ),
      );
    }

    return series;
  }

  DateFormat _getDateFormat() {
    switch (period?.toLowerCase()) {
      case 'monthly':
        return DateFormat('MMM yyyy');
      case 'yearly':
        return DateFormat('yyyy');
      default:
        return DateFormat('MMM dd');
    }
  }

  DateTimeIntervalType _getIntervalType() {
    switch (period?.toLowerCase()) {
      case 'monthly':
        return DateTimeIntervalType.months;
      case 'yearly':
        return DateTimeIntervalType.years;
      default:
        return DateTimeIntervalType.days;
    }
  }
}
