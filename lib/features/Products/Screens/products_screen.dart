import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pos/core/constraints/colors.dart';
import 'package:pos/core/constraints/fonts.dart';
import 'package:pos/core/constraints/spacing.dart';
import 'package:pos/core/models/products.dart';
import 'package:pos/core/services/export_service.dart';
import 'package:pos/core/services/search_service.dart';
import 'package:pos/features/products/widgets/product_table.dart';
import 'package:pos/features/products/widgets/add_product_form.dart';
import 'package:pos/features/products/widgets/product_button_toolbar.dart';
import 'package:pos/features/products/widgets/import_preview.dart';
import 'package:pos/features/products/widgets/low_stock_filter.dart'; // Import the new widget

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _searchQueryController = TextEditingController();
  List<Product> _filteredProducts = [];
  bool _showLowStock = false; // Flag to toggle low stock filter

  @override
  void initState() {
    super.initState();
    _refreshProductList();
  }

  void _refreshProductList() {
    setState(() {
      // Get products based on search query
      List<Product> products = SearchService.searchProducts(
        _searchQueryController.text,
      );

      // Apply low stock filter if enabled
      if (_showLowStock) {
        products =
            products.where((product) {
              // Check if reorderLevel is set and stockQuantity is below it
              return product.reorderLevel != null &&
                  product.stockQuantity < product.reorderLevel!;
            }).toList();
      }

      _filteredProducts = products;
    });
  }

  void _toggleLowStock() {
    setState(() {
      _showLowStock = !_showLowStock;
      _refreshProductList();
    });
    // Show a SnackBar to indicate the filter state
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(
    //       _showLowStock ? 'Showing low stock products' : 'Showing all products',
    //     ),
    //   ),
    // );
  }

  void _importExcel() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );
    if (result != null && result.files.single.path != null) {
      showDialog(
        context: context,
        builder:
            (context) => ImportPreview(
              filePath: result.files.single.path!,
              onImport: _refreshProductList,
              onCancel: () => Navigator.of(context).pop(),
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.all(AppSpacing.small(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Products', style: AppFonts.appBarTitle),
          SizedBox(height: AppSpacing.small(context)),
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: AppSpacing.small(context),
                      runSpacing: AppSpacing.small(context),
                      children: [
                        ProductButtonToolbar(
                          // onView: () {
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     const SnackBar(content: Text('View clicked')),
                          //   );
                          // },
                          // onSearch: () {},
                          onRefresh: _refreshProductList,
                          onExport: () async {
                            await ExportService.exportToExcel(context);
                          },
                          // onBulkUpload: () {
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     const SnackBar(
                          //       content: Text('Bulk Upload clicked'),
                          //     ),
                          //   );
                          // },
                          onImportExcel: _importExcel,
                          onBarcodePrint: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Comming Soon')),
                            );
                          },
                          lowStockFilter: LowStockFilter(
                            onToggle: _toggleLowStock,
                            showLowStock: _showLowStock,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: AppSpacing.medium(context)),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AddProductForm(
                              onProductAdded: _refreshProductList,
                            ),
                      );
                    },
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
                      'Add Product',
                      style: AppFonts.bodyText.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: AppSpacing.medium(context)),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.small(context),
            ),
            child: TextField(
              controller: _searchQueryController,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) => _refreshProductList(),
            ),
          ),
          SizedBox(height: AppSpacing.height(context, 0.0005)),
          Expanded(child: ProductTable(products: _filteredProducts)),
        ],
      ),
    );
  }
}
