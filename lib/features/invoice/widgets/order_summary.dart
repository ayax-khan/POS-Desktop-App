import 'package:flutter/material.dart';
import 'package:pos/core/constraints/fonts.dart';
import 'package:pos/core/constraints/spacing.dart';
import 'package:pos/core/models/products.dart';

class OrderSummary extends StatelessWidget {
  final List<Map<String, dynamic>> selectedProducts;
  final double totalAmount;

  const OrderSummary({
    super.key,
    required this.selectedProducts,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.medium(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: AppFonts.bodyText.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.014,
              ),
            ),
            SizedBox(height: AppSpacing.medium(context)),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: selectedProducts.length,
              itemBuilder: (context, index) {
                final item = selectedProducts[index];
                final product = item['product'] as Product;
                final quantity = item['quantity'] as int;
                final subtotal = product.sellingPrice * quantity;
                return ListTile(
                  title: Text('${product.name} x $quantity'),
                  subtitle: Text('Subtotal: \$${subtotal.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () {},
                  ),
                );
              },
            ),
            Divider(height: AppSpacing.large(context)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Total: \$${totalAmount.toStringAsFixed(2)}',
                  style: AppFonts.bodyText.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.014,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
