import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:pos/features/Reports/Models/revenue_data.dart';
import 'base_chart.dart';

class RevenueBarChart extends BaseChart {
  const RevenueBarChart({
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
      title: ChartTitle(text: 'Trend Analysis - Bar Chart'),
      legend: Legend(isVisible: true, position: LegendPosition.bottom),
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

  List<CartesianSeries<ChartDataPoint, DateTime>> _getChartSeries() {
    final List<CartesianSeries<ChartDataPoint, DateTime>> series = [];

    // For bar chart, we use ColumnSeries instead of LineSeries
    if (selectedMetrics.contains('Revenue') && revenueData.isNotEmpty) {
      series.add(
        ColumnSeries<ChartDataPoint, DateTime>(
          name: 'Revenue',
          dataSource: revenueData,
          xValueMapper: (data, _) => data.date,
          yValueMapper: (data, _) => data.value,
          color: Colors.blue,
        ),
      );
    }

    if (selectedMetrics.contains('Customers') && visitorsData.isNotEmpty) {
      series.add(
        ColumnSeries<ChartDataPoint, DateTime>(
          name: 'Customers',
          dataSource: visitorsData,
          xValueMapper: (data, _) => data.date,
          yValueMapper: (data, _) => data.value,
          color: Colors.orange,
        ),
      );
    }

    if (selectedMetrics.contains('Products') && productsData.isNotEmpty) {
      series.add(
        ColumnSeries<ChartDataPoint, DateTime>(
          name: 'Products',
          dataSource: productsData,
          xValueMapper: (data, _) => data.date,
          yValueMapper: (data, _) => data.value,
          color: Colors.green,
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
