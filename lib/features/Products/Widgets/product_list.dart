import 'package:flutter/material.dart';
import 'package:pos/core/constraints/fonts.dart';
import 'package:pos/core/constraints/spacing.dart';
import 'package:pos/core/services/hive_service.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    final products = HiveService.getProducts();

    return Container(
      padding: EdgeInsets.all(AppSpacing.medium(context)), // Dynamic padding
      child:
          products.isEmpty
              ? Center(
                child: Text(
                  'No products available. Add some!',
                  style: AppFonts.bodyText,
                ),
              )
              : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(
                      vertical: AppSpacing.small(context), // Dynamic spacing
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(
                        AppSpacing.medium(context),
                      ), // Dynamic padding
                      title: Text(
                        product.name,
                        style: AppFonts.bodyText.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Price: \$${product.sellingPrice} | Quantity: ${product.stockQuantity} | Category: ${product.category}',
                        style: AppFonts.bodyText,
                      ),
                      trailing: Icon(
                        product.stockQuantity < (product.reorderLevel ?? 10)
                            ? Icons.warning
                            : null,
                        color: Colors.orange,
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
