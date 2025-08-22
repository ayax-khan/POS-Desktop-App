import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pos/core/models/products.dart';
import 'package:pos/features/Products/Widgets/product_table_component/product_action.dart';

class ProductTableRow {
  final Product product;
  final VoidCallback onStateChanged;

  ProductTableRow({required this.product, required this.onStateChanged});

  DataRow toDataRow(BuildContext context) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            product.name,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.012,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          Text(
            '\$${product.sellingPrice.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.012,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          Text(
            product.stockQuantity.toString(),
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.012,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          Text(
            product.category,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.012,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          Text(
            product.brand ?? 'N/A',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.012,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          product.imagePath != null && product.imagePath!.isNotEmpty
              ? SizedBox(
                width: MediaQuery.of(context).size.width * 0.04,
                height: MediaQuery.of(context).size.width * 0.04,
                child:
                    product.imagePath!.startsWith('http')
                        ? Image.network(
                          product.imagePath!,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image),
                        )
                        : Image.file(
                          File(product.imagePath!),
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image),
                        ),
              )
              : const Icon(Icons.image_not_supported),
        ),
        DataCell(
          ProductActions(product: product, onStateChanged: onStateChanged),
        ),
      ],
    );
  }
}
