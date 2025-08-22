import 'package:flutter/material.dart';
import 'package:pos/core/constraints/colors.dart';
import 'package:pos/core/constraints/fonts.dart';
import 'package:pos/core/constraints/spacing.dart';
import 'package:pos/features/products/widgets/low_stock_filter.dart'; // Import the new widget

class ProductButtonToolbar extends StatelessWidget {
  final VoidCallback? onView;
  final VoidCallback? onRefresh;
  final VoidCallback? onExport;
  // final VoidCallback? onBulkUpload;
  final VoidCallback? onImportExcel;
  final VoidCallback? onBarcodePrint;
  final LowStockFilter? lowStockFilter;

  const ProductButtonToolbar({
    super.key,
    this.onView,
    this.onRefresh,
    this.onExport,
    // this.onBulkUpload,
    this.onImportExcel,
    this.onBarcodePrint,
    this.lowStockFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.medium(context)),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Wrap(
        spacing: AppSpacing.small(context),
        runSpacing: AppSpacing.small(context),
        children: [
          if (onView != null)
            _buildButton(
              context,
              label: 'View',
              icon: Icons.visibility,
              tooltip: 'View product details',
              color: AppColors.primary,
              onPressed: onView,
            ),
          if (onRefresh != null)
            _buildButton(
              context,
              label: 'Refresh',
              icon: Icons.refresh,
              tooltip: 'Refresh product list',
              color: AppColors.secondary,
              onPressed: onRefresh,
            ),
          if (onExport != null)
            _buildButton(
              context,
              label: 'Export',
              icon: Icons.file_download,
              tooltip: 'Export to Excel',
              color: AppColors.secondary,
              onPressed: onExport,
              showSnackBar: false,
            ),
          if (onImportExcel != null)
            _buildButton(
              context,
              label: 'Import Excel',
              icon: Icons.table_chart,
              tooltip: 'Import from Excel',
              color: AppColors.secondary,
              onPressed: onImportExcel,
            ),
          if (onBarcodePrint != null)
            _buildButton(
              context,
              label: 'Barcode Print',
              icon: Icons.qr_code,
              tooltip: 'Print barcodes',
              color: AppColors.secondary,
              onPressed: onBarcodePrint,
            ),
          if (lowStockFilter != null) lowStockFilter!,
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required String tooltip,
    Color color = Colors.blue,
    VoidCallback? onPressed,
    final bool showSnackBar = true,
  }) {
    return Tooltip(
      message: tooltip,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: MediaQuery.of(context).size.width * 0.015,
          color: Colors.white,
        ),
        label: Text(
          label,
          style: AppFonts.bodyText.copyWith(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width * 0.01,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
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
