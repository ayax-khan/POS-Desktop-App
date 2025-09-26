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
import 'package:pos/features/products/widgets/low_stock_filter.dart';
import 'package:pos/features/returns/services/returns_service.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _searchQueryController = TextEditingController();
  List<Product> _filteredProducts = [];
  bool _showLowStock = false; // Flag to toggle low stock filter
  bool _isReturnMode = false; // Flag to toggle return mode
  List<Product> _returnSearchResults = [];

  @override
  void initState() {
    super.initState();
    _refreshProductList();
  }

  void _refreshProductList() {
    setState(() {
      if (_isReturnMode) {
        // In return mode, show search results
        _returnSearchResults = ReturnsService.searchProductsForReturn(
          _searchQueryController.text,
        );
      } else {
        // Normal mode - Get products based on search query
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
      }
    });
  }

  void _toggleReturnMode() {
    setState(() {
      _isReturnMode = !_isReturnMode;
      _searchQueryController.clear();
      _returnSearchResults.clear();
      if (!_isReturnMode) {
        _refreshProductList();
      }
    });
  }

  void _processReturn(Product product) async {
    final quantityController = TextEditingController();
    final reasonController = TextEditingController();
    final customerController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Return Product: ${product.name}'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Quantity to Return',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: reasonController,
                    decoration: const InputDecoration(
                      labelText: 'Return Reason',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: customerController,
                    decoration: const InputDecoration(
                      labelText: 'Customer Name (Optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final quantity = int.tryParse(quantityController.text) ?? 0;
                  if (quantity > 0 && reasonController.text.isNotEmpty) {
                    final success = await ReturnsService.processReturn(
                      productId: product.id,
                      quantityToReturn: quantity,
                      reason: reasonController.text,
                      customerName:
                          customerController.text.isEmpty
                              ? null
                              : customerController.text,
                    );

                    Navigator.pop(context);

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Product return processed successfully!',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                      _refreshProductList();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Failed to process return. Please try again.',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please enter valid quantity and reason.',
                        ),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                },
                child: const Text('Process Return'),
              ),
            ],
          ),
    );
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
                          onRefresh: _refreshProductList,
                          onExport: () async {
                            await ExportService.exportToExcel(context);
                          },
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
                    onPressed: _toggleReturnMode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isReturnMode ? Colors.red : Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.large(context),
                        vertical: AppSpacing.medium(context),
                      ),
                    ),
                    child: Text(
                      _isReturnMode ? 'Exit Return Mode' : 'Return Products',
                      style: AppFonts.bodyText.copyWith(color: Colors.white),
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
                labelText:
                    _isReturnMode
                        ? 'Search by SKU or Name for Return'
                        : 'Search',
                prefixIcon: Icon(
                  _isReturnMode ? Icons.assignment_return : Icons.search,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: _isReturnMode ? Colors.orange.shade50 : Colors.white,
              ),
              onChanged: (value) => _refreshProductList(),
            ),
          ),
          SizedBox(height: AppSpacing.height(context, 0.0005)),
          if (_isReturnMode && _returnSearchResults.isNotEmpty)
            Container(
              height: 200,
              margin: EdgeInsets.symmetric(
                horizontal: AppSpacing.small(context),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.assignment_return,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Products Found for Return (${_returnSearchResults.length})',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _returnSearchResults.length,
                      itemBuilder: (context, index) {
                        final product = _returnSearchResults[index];
                        return ListTile(
                          leading: const Icon(
                            Icons.inventory,
                            color: Colors.grey,
                          ),
                          title: Text(product.name),
                          subtitle: Text(
                            'SKU: ${product.sku ?? 'N/A'} | Stock: ${product.stockQuantity} | Price: \$${product.sellingPrice.toStringAsFixed(2)}',
                          ),
                          trailing: ElevatedButton(
                            onPressed: () => _processReturn(product),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Return'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          if (_isReturnMode && _returnSearchResults.isNotEmpty)
            SizedBox(height: AppSpacing.medium(context)),
          Expanded(
            child:
                _isReturnMode
                    ? Container(
                      padding: const EdgeInsets.all(20),
                      child: const Center(
                        child: Text(
                          'Search for products above to process returns',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    )
                    : ProductTable(products: _filteredProducts),
          ),
        ],
      ),
    );
  }
}
