import 'package:flutter/material.dart';
import 'package:pos/core/constraints/colors.dart';
import 'package:pos/core/constraints/spacing.dart';
import 'package:pos/core/models/products.dart';
import 'package:pos/core/services/hive_service.dart';
import 'package:pos/features/Products/Widgets/product_table_component/product_detail_view_screen.dart';
import 'package:pos/features/products/widgets/add_product_form.dart';

class ProductActions extends StatefulWidget {
  final Product product;
  final VoidCallback onStateChanged;

  const ProductActions({
    super.key,
    required this.product,
    required this.onStateChanged,
  });

  @override
  State<ProductActions> createState() => _ProductActionsState();
}

class _ProductActionsState extends State<ProductActions> {
  void _toggleFavorite(String id) {
    HiveService.toggleFavorite(id).then((_) {
      widget.onStateChanged();
    });
  }

  void _editProduct(Product product) {
    showDialog(
      context: context,
      builder:
          (context) => AddProductForm(
            onProductAdded: () => widget.onStateChanged(),
            productToEdit: product,
          ),
    );
  }

  Future<void> _deleteProduct(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Deletion'),
            content: const Text(
              'Are you sure you want to delete this product?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      HiveService.deleteProduct(id).then((_) {
        widget.onStateChanged();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product deleted successfully!')),
        );
      });
    }
  }

  void _viewProduct(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            widget.product.favorite ? Icons.star : Icons.star_border,
            size: MediaQuery.of(context).size.width * 0.015,
            color: widget.product.favorite ? AppColors.primary : null,
          ),
          onPressed: () => _toggleFavorite(widget.product.id),
        ),
        Spacer(),
        IconButton(
          icon: Icon(
            Icons.edit,
            size: MediaQuery.of(context).size.width * 0.015,
            color: AppColors.primary,
          ),
          onPressed: () => _editProduct(widget.product),
        ),
        Spacer(),
        IconButton(
          icon: Icon(
            Icons.delete,
            size: MediaQuery.of(context).size.width * 0.015,
            color: Colors.red,
          ),
          onPressed: () => _deleteProduct(widget.product.id),
        ),
        Spacer(),
        ElevatedButton(
          onPressed: () => _viewProduct(widget.product),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.small(context),
              vertical: AppSpacing.small(context),
            ),
            minimumSize: Size(MediaQuery.of(context).size.width * 0.05, 0),
          ),
          child: Text(
            'View',
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.width * 0.008,
            ),
          ),
        ),
      ],
    );
  }
}
