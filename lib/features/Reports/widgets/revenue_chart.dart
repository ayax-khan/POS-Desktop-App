import 'package:flutter/material.dart';
import 'package:pos/core/constraints/colors.dart';
import 'package:pos/core/constraints/fonts.dart';
import 'package:pos/core/constraints/spacing.dart';
import 'package:pos/features/Reports/Models/revenue_data.dart';

class RevenueChart extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      height: 350,
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
          Expanded(child: _buildChart(context)),
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
        SizedBox(height: 12),
        // Show selected metrics as chips
        Wrap(
          spacing: 8,
          children: selectedMetrics.map((metric) {
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
                style: TextStyle(color: Colors.white, fontSize: 12),
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

  Widget _buildChart(BuildContext context) {
    if (revenueData.isEmpty &&
        visitorsData.isEmpty &&
        productsData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics_outlined, size: 48, color: Colors.grey.shade400),
            SizedBox(height: AppSpacing.small(context)),
            Text(
              'No data available for this period',
              style: AppFonts.bodyText.copyWith(
                color: Colors.grey.shade500,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return CustomPaint(
      painter: ChartPainter(
        revenueData: revenueData,
        visitorsData: visitorsData,
        productsData: productsData,
        selectedMetrics: selectedMetrics,
        period: period,
      ),
      size: Size.infinite,
    );
  }
}

class ChartPainter extends CustomPainter {
  final List<ChartDataPoint> revenueData;
  final List<ChartDataPoint> visitorsData;
  final List<ChartDataPoint> productsData;
  final Set<String> selectedMetrics;
  final String? period;

  ChartPainter({
    required this.revenueData,
    required this.visitorsData,
    required this.productsData,
    required this.selectedMetrics,
    this.period,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final revenuePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final visitorsPaint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final productsPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final gridPaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 1;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    _drawGrid(canvas, size, gridPaint);

    if (selectedMetrics.contains('Revenue') && revenueData.isNotEmpty) {
      _drawLine(canvas, size, revenueData, revenuePaint);
      _drawDataPoints(canvas, size, revenueData, Colors.blue);
    }

    if (selectedMetrics.contains('Customers') && visitorsData.isNotEmpty) {
      _drawLine(canvas, size, visitorsData, visitorsPaint);
      _drawDataPoints(canvas, size, visitorsData, Colors.orange);
    }

    if (selectedMetrics.contains('Products') && productsData.isNotEmpty) {
      _drawLine(canvas, size, productsData, productsPaint);
      _drawDataPoints(canvas, size, productsData, Colors.green);
    }

    _drawLegend(canvas, size, textPainter);
  }

  void _drawGrid(Canvas canvas, Size size, Paint gridPaint) {
    const gridLines = 5;
    final stepX = size.width / gridLines;
    final stepY = size.height / gridLines;

    for (int i = 0; i <= gridLines; i++) {
      final x = i * stepX;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    for (int i = 0; i <= gridLines; i++) {
      final y = i * stepY;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  void _drawLine(Canvas canvas, Size size, List<ChartDataPoint> data, Paint paint) {
    if (data.isEmpty) return;

    final path = Path();
    final maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final minValue = data.map((e) => e.value).reduce((a, b) => a < b ? a : b);
    final valueRange = maxValue - minValue;

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final normalizedValue =
          valueRange == 0 ? 0.5 : (data[i].value - minValue) / valueRange;
      final y = size.height - (normalizedValue * size.height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  void _drawDataPoints(Canvas canvas, Size size, List<ChartDataPoint> data, Color color) {
    if (data.isEmpty) return;

    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final minValue = data.map((e) => e.value).reduce((a, b) => a < b ? a : b);
    final valueRange = maxValue - minValue;

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final normalizedValue =
          valueRange == 0 ? 0.5 : (data[i].value - minValue) / valueRange;
      final y = size.height - (normalizedValue * size.height);

      canvas.drawCircle(Offset(x, y), 4, pointPaint);
    }
  }

  void _drawLegend(Canvas canvas, Size size, TextPainter textPainter) {
    final legendY = size.height + 20;
    double startX = 10;

    if (selectedMetrics.contains('Revenue')) {
      canvas.drawCircle(Offset(startX, legendY), 4, Paint()..color = Colors.blue);
      textPainter.text = TextSpan(
        text: 'Revenue',
        style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(startX + 10, legendY - 6));
      startX += 80;
    }

    if (selectedMetrics.contains('Products')) {
      canvas.drawCircle(Offset(startX, legendY), 4, Paint()..color = Colors.green);
      textPainter.text = TextSpan(
        text: 'Products',
        style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(startX + 10, legendY - 6));
      startX += 80;
    }

    if (selectedMetrics.contains('Customers')) {
      canvas.drawCircle(Offset(startX, legendY), 4, Paint()..color = Colors.orange);
      textPainter.text = TextSpan(
        text: 'Customers',
        style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(startX + 10, legendY - 6));
    }
  }

  @override
  bool shouldRepaint(ChartPainter oldDelegate) {
    return oldDelegate.revenueData != revenueData ||
        oldDelegate.visitorsData != visitorsData ||
        oldDelegate.productsData != productsData ||
        oldDelegate.selectedMetrics != selectedMetrics;
  }
}