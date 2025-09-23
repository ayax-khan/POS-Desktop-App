import 'package:flutter/material.dart';
import 'package:pos/core/constraints/fonts.dart';

enum ChartType { line, bar, pie }

class ChartSelector extends StatelessWidget {
  final ChartType selectedChartType;
  final Function(ChartType) onChartTypeChanged;

  const ChartSelector({
    super.key,
    required this.selectedChartType,
    required this.onChartTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Chart Type: ',
          style: AppFonts.bodyText.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 12),
        _buildChartTypeChip(
          context,
          ChartType.line,
          Icons.show_chart,
          'Line Chart',
        ),
        const SizedBox(width: 8),
        _buildChartTypeChip(
          context,
          ChartType.bar,
          Icons.bar_chart,
          'Bar Chart',
        ),
        const SizedBox(width: 8),
        _buildChartTypeChip(
          context,
          ChartType.pie,
          Icons.pie_chart,
          'Pie Chart',
        ),
      ],
    );
  }

  Widget _buildChartTypeChip(
    BuildContext context,
    ChartType type,
    IconData icon,
    String label,
  ) {
    final isSelected = selectedChartType == type;

    return FilterChip(
      selected: isSelected,
      onSelected: (_) => onChartTypeChanged(type),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 16), const SizedBox(width: 4), Text(label)],
      ),
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      checkmarkColor: Theme.of(context).primaryColor,
      labelStyle: AppFonts.bodyText.copyWith(
        fontSize: 12,
        color:
            isSelected ? Theme.of(context).primaryColor : Colors.grey.shade700,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color:
              isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade300,
        ),
      ),
    );
  }
}
