import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:pos/core/constraints/colors.dart';
import 'package:pos/core/constraints/spacing.dart';
import 'package:pos/core/models/products.dart';
import 'package:pos/core/services/hive_service.dart';
import 'package:ulid/ulid.dart';

class ImportPreview extends StatefulWidget {
  final String filePath;
  final VoidCallback onImport;
  final VoidCallback onCancel;

  const ImportPreview({
    super.key,
    required this.filePath,
    required this.onImport,
    required this.onCancel,
  });

  @override
  State<ImportPreview> createState() => _ImportPreviewState();
}

class _ImportPreviewState extends State<ImportPreview> {
  late List<List<dynamic>> _data;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final bytes = await File(widget.filePath).readAsBytes();
    final excel = Excel.decodeBytes(bytes);
    final sheet = excel.tables.keys.first;
    setState(() {
      _data = excel.tables[sheet]!.rows;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Preview Import Data'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
        height:
            MediaQuery.of(context).size.height * 0.5, // 50% of screen height
        child:
            _data.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: AppSpacing.medium(context),
                      headingRowColor: WidgetStateProperty.all(
                        AppColors.primary.withOpacity(0.1),
                      ),
                      columns: List.generate(
                        _data[0].length,
                        (index) => DataColumn(
                          label: Text(
                            'Column $index',
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.01,
                            ),
                          ),
                        ),
                      ),
                      rows:
                          _data.skip(1).map((row) {
                            return DataRow(
                              cells:
                                  row
                                      .map(
                                        (cell) => DataCell(
                                          Text(
                                            cell?.toString() ?? '',
                                            style: TextStyle(
                                              fontSize:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.01,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                            );
                          }).toList(),
                    ),
                  ),
                ),
      ),
      actions: [
        TextButton(
          onPressed: widget.onCancel,
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.01,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            int importedCount = 0;
            for (var row in _data.skip(1)) {
              if (row.length >= 6) {
                final product = Product(
                  id: Ulid().toString(),
                  name: row[0]?.value.toString() ?? 'Unnamed',
                  category: row[1]?.value.toString() ?? 'Uncategorized',
                  purchasePrice:
                      double.tryParse(row[2]?.value.toString() ?? '0.0') ?? 0.0,
                  sellingPrice:
                      double.tryParse(row[3]?.value.toString() ?? '0.0') ?? 0.0,
                  stockQuantity:
                      int.tryParse(row[4]?.value.toString() ?? '0') ?? 0,
                  unit: row[5]?.value.toString() ?? 'pcs',
                  brand: row.length > 6 ? row[6]?.value.toString() : null,
                  sku: row.length > 7 ? row[7]?.value.toString() : null,
                  barcode: row.length > 8 ? row[8]?.value.toString() : null,
                  expiryDate:
                      row.length > 9
                          ? DateTime.tryParse(row[9]?.value.toString() ?? '')
                          : null,
                  imagePath: null,
                  description:
                      row.length > 10 ? row[10]?.value.toString() : null,
                  tax:
                      row.length > 11
                          ? double.tryParse(row[11]?.value.toString() ?? '')
                          : null,
                  supplierInfo:
                      row.length > 12 ? row[12]?.value.toString() : null,
                  discount:
                      row.length > 13
                          ? double.tryParse(row[13]?.value.toString() ?? '')
                          : null,
                  reorderLevel:
                      row.length > 14
                          ? int.tryParse(row[14]?.value.toString() ?? '')
                          : null,
                );
                await HiveService.addProduct(product);
                importedCount++;
              }
            }
            widget.onImport();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Imported $importedCount products successfully!'),
              ),
            );
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: Text(
            'Import',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.01,
            ),
          ),
        ),
      ],
    );
  }
}
