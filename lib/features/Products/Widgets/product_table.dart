import 'package:flutter/material.dart';
import 'package:pos/core/constraints/colors.dart';
import 'package:pos/core/constraints/spacing.dart';
import 'package:pos/core/models/products.dart';
import 'package:pos/features/Products/Widgets/product_table_component/product_table_column.dart';
import 'package:pos/features/Products/Widgets/product_table_component/product_table_row.dart';

class ProductTable extends StatefulWidget {
  final List<Product> products;

  const ProductTable({super.key, required this.products});

  @override
  State<ProductTable> createState() => _ProductTableState();
}

class _ProductTableState extends State<ProductTable> {
  void _refreshTable() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.medium(context)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tableWidth = constraints.maxWidth;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
                width: tableWidth,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(
                    AppColors.primary.withOpacity(0.1),
                  ),
                  border: TableBorder(
                    top: const BorderSide(width: 1, color: Colors.grey),
                    bottom: const BorderSide(width: 1, color: Colors.grey),
                    left: const BorderSide(width: 1, color: Colors.grey),
                    right: const BorderSide(width: 1, color: Colors.grey),
                    verticalInside: const BorderSide(
                      width: 1,
                      color: Colors.grey,
                    ),
                    horizontalInside: const BorderSide(
                      width: 1,
                      color: Colors.grey,
                    ),
                  ),
                  columnSpacing: AppSpacing.medium(context),
                  columns: const ProductTableColumns().getColumns(context),
                  rows:
                      widget.products.map((product) {
                        return ProductTableRow(
                          product: product,
                          onStateChanged: _refreshTable,
                        ).toDataRow(context);
                      }).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
