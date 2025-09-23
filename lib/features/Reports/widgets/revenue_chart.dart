import 'package:flutter/material.dart';
import 'package:pos/core/constraints/fonts.dart';
import 'package:pos/core/constraints/spacing.dart';
import 'package:pos/features/Reports/Models/revenue_data.dart';
import 'package:pos/features/Reports/components/chart_selector.dart';
import 'package:pos/features/Reports/components/line_chart.dart';
import 'package:pos/features/Reports/components/bar_chart.dart';
import 'package:pos/features/Reports/components/pie_chart.dart';

class RevenueChart extends StatefulWidget {
  final List<ChartDataPoint> revenueData;
  final List<ChartDataPoint> visitorsData;
  final List<ChartDataPoint> productsData;
  final Set<String> selectedMetrics;
  final String? period;

  const RevenueChart({
    super.key,
    required this.revenueData,
    required this.visitorsData,
    required this.productsData,
    required this.selectedMetrics,
    this.period,
  });

  @override
  State<RevenueChart> createState() => _RevenueChartState();
}

class _RevenueChartState extends State<RevenueChart> {
  ChartType _selectedChartType = ChartType.line;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
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
          _buildChartHeader(context),
          SizedBox(height: AppSpacing.medium(context)),
          ChartSelector(
            selectedChartType: _selectedChartType,
            onChartTypeChanged: (type) {
              setState(() {
                _selectedChartType = type;
              });
            },
          ),
          SizedBox(height: AppSpacing.medium(context)),
          Expanded(child: _buildSelectedChart()),
        ],
      ),
    );
  }

  Widget _buildChartHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trend Analysis',
          style: AppFonts.heading.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Revenue, Products & Customer trends',
          style: AppFonts.bodyText.copyWith(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children:
              widget.selectedMetrics.map((metric) {
                Color color;
                switch (metric) {
                  case 'Revenue':
                    color = Colors.blue;
                    break;
                  case 'Products':
                    color = Colors.green;
                    break;
                  case 'Customers':
                    color = Colors.orange;
                    break;
                  default:
                    color = Colors.grey;
                }
                return Chip(
                  label: Text(
                    metric,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  backgroundColor: color,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildSelectedChart() {
    switch (_selectedChartType) {
      case ChartType.line:
        return RevenueLineChart(
          revenueData: widget.revenueData,
          visitorsData: widget.visitorsData,
          productsData: widget.productsData,
          selectedMetrics: widget.selectedMetrics,
          period: widget.period,
        );
      case ChartType.bar:
        return RevenueBarChart(
          revenueData: widget.revenueData,
          visitorsData: widget.visitorsData,
          productsData: widget.productsData,
          selectedMetrics: widget.selectedMetrics,
          period: widget.period,
        );
      case ChartType.pie:
        return RevenuePieChart(
          revenueData: widget.revenueData,
          visitorsData: widget.visitorsData,
          productsData: widget.productsData,
          selectedMetrics: widget.selectedMetrics,
          period: widget.period,
        );
    }
  }
}
