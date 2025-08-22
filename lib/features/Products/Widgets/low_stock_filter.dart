import 'package:flutter/material.dart';
import 'package:pos/core/constraints/fonts.dart';
import 'package:pos/core/constraints/spacing.dart';

class LowStockFilter extends StatefulWidget {
  final VoidCallback onToggle; // Callback to toggle the filter in the parent
  final bool showLowStock; // Current state of the filter

  const LowStockFilter({
    super.key,
    required this.onToggle,
    required this.showLowStock,
  });

  @override
  State<LowStockFilter> createState() => _LowStockFilterState();
}

class _LowStockFilterState extends State<LowStockFilter> {
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message:
          widget.showLowStock ? 'Show all products' : 'Show low stock items',
      child: ElevatedButton.icon(
        onPressed: () {
          widget.onToggle();
        },
        icon: Icon(
          widget.showLowStock ? Icons.inventory : Icons.warning,
          size: MediaQuery.of(context).size.width * 0.015,
          color: Colors.white,
        ),
        label: Text(
          widget.showLowStock ? 'Full Stock' : 'Low Stock',
          style: AppFonts.bodyText.copyWith(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width * 0.01,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.showLowStock ? Colors.green : Colors.orange,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.medium(context),
            vertical: AppSpacing.small(context),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
        ),
      ),
    );
  }
}
