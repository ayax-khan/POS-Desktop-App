import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pos/core/constraints/colors.dart';
import 'package:pos/core/constraints/fonts.dart';
import 'package:pos/core/constraints/spacing.dart';
import 'package:pos/core/models/products.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details', style: AppFonts.appBarTitle),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.medium(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child:
                  product.imagePath != null && product.imagePath!.isNotEmpty
                      ? SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.width * 0.3,
                        child:
                            product.imagePath!.startsWith('http')
                                ? Image.network(
                                  product.imagePath!,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Icon(
                                            Icons.broken_image,
                                            size: 50,
                                          ),
                                )
                                : Image.file(
                                  File(product.imagePath!),
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Icon(
                                            Icons.broken_image,
                                            size: 50,
                                          ),
                                ),
                      )
                      : const Icon(Icons.image_not_supported, size: 50),
            ),
            SizedBox(height: AppSpacing.large(context)),
            _buildDetailRow(context, 'Title', product.name),
            _buildDetailRow(
              context,
              'Price',
              '\$${product.sellingPrice.toStringAsFixed(2)}',
            ),
            _buildDetailRow(
              context,
              'Quantity',
              product.stockQuantity.toString(),
            ),
            _buildDetailRow(context, 'Category', product.category),
            _buildDetailRow(context, 'Brand', product.brand ?? 'N/A'),
            _buildDetailRow(context, 'Unit', product.unit),
            _buildDetailRow(context, 'SKU', product.sku ?? 'N/A'),
            _buildDetailRow(context, 'Barcode', product.barcode ?? 'N/A'),
            _buildDetailRow(
              context,
              'Expiry Date',
              product.expiryDate?.toIso8601String().split('T')[0] ?? 'N/A',
            ),
            _buildDetailRow(
              context,
              'Description',
              product.description ?? 'N/A',
            ),
            _buildDetailRow(
              context,
              'Tax',
              product.tax != null ? '${product.tax}%' : 'N/A',
            ),
            _buildDetailRow(
              context,
              'Supplier Info',
              product.supplierInfo ?? 'N/A',
            ),
            _buildDetailRow(
              context,
              'Discount',
              product.discount != null ? '${product.discount}%' : 'N/A',
            ),
            _buildDetailRow(
              context,
              'Reorder Level',
              product.reorderLevel != null
                  ? product.reorderLevel.toString()
                  : 'N/A',
            ),
            _buildDetailRow(
              context,
              'Favorite',
              product.favorite ? 'Yes' : 'No',
            ),
            SizedBox(height: AppSpacing.large(context)),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.large(context),
                    vertical: AppSpacing.medium(context),
                  ),
                ),
                child: Text(
                  'Close',
                  style: AppFonts.bodyText.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.small(context)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            child: Text(
              '$label:',
              style: AppFonts.bodyText.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.012,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppFonts.bodyText.copyWith(
                fontSize: MediaQuery.of(context).size.width * 0.012,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
