import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pos/core/services/hive_service.dart';

class ExportService {
  static Future<void> exportToExcel(BuildContext context) async {
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    // Add header row
    sheet.appendRow([
      TextCellValue('Name'),
      TextCellValue('Category'),
      TextCellValue('Purchase Price'),
      TextCellValue('Selling Price'),
      TextCellValue('Stock Quantity'),
      TextCellValue('Unit'),
      TextCellValue('Brand'),
      TextCellValue('SKU'),
      TextCellValue('Barcode'),
      TextCellValue('Expiry Date'),
      TextCellValue('Description'),
      TextCellValue('Tax'),
      TextCellValue('Supplier Info'),
      TextCellValue('Discount'),
      TextCellValue('Reorder Level'),
    ]);

    // Add data rows
    final products = HiveService.getProducts();
    for (var product in products) {
      sheet.appendRow([
        TextCellValue(product.name),
        TextCellValue(product.category),
        DoubleCellValue(product.purchasePrice),
        DoubleCellValue(product.sellingPrice),
        IntCellValue(product.stockQuantity),
        TextCellValue(product.unit),
        TextCellValue(product.brand ?? ''),
        TextCellValue(product.sku ?? ''),
        TextCellValue(product.barcode ?? ''),
        TextCellValue(product.expiryDate?.toIso8601String() ?? ''),
        TextCellValue(product.description ?? ''),
        product.tax != null ? DoubleCellValue(product.tax!) : TextCellValue(''),
        TextCellValue(product.supplierInfo ?? ''),
        product.discount != null
            ? DoubleCellValue(product.discount!)
            : TextCellValue(''),
        product.reorderLevel != null
            ? IntCellValue(product.reorderLevel!)
            : TextCellValue(''),
      ]);
    }

    // Prompt user to choose save location
    String? savePath = await FilePicker.platform.saveFile(
      dialogTitle: 'Save Excel File',
      fileName: 'products_export.xlsx',
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    final file = File(savePath!);
    await file.writeAsBytes(excel.encode()!);
    print('Excel file saved at: ${file.path}');
  }
}
