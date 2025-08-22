import 'package:flutter/material.dart';
import 'package:pos/core/constraints/colors.dart';
import 'package:pos/core/constraints/fonts.dart';
import 'package:pos/core/constraints/spacing.dart';
import 'package:pos/core/models/products.dart';
import 'package:pos/core/services/hive_service.dart';
import 'package:pos/features/invoice/model/order.dart';
import 'package:pos/features/invoice/receipt_templates/receipt_template_1.dart';
import 'package:pos/features/invoice/receipt_templates/receipt_template_2.dart';
import 'package:pos/features/invoice/receipt_templates/receipt_template_3.dart';
import 'package:pos/features/invoice/receipt_templates/receipt_template_4.dart';

class CreateOrderScreen extends StatefulWidget {
  final int? selectedTemplate;
  const CreateOrderScreen({super.key, this.selectedTemplate});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _searchController = TextEditingController();
  final _customerController = TextEditingController();
  List<Map<String, dynamic>> _selectedProducts = [];
  double _totalAmount = 0.0;
  bool _isLoading = true;
  String _orderNumber = "";
  int? _selectedTemplateId; // Added to store selected template ID

  @override
  void initState() {
    super.initState();
    _selectedTemplateId = widget.selectedTemplate; // Initialize with selected template
    _loadDraftOrder();
    _generateOrderNumber();
  }

  @override
  void dispose() {
    _saveDraftOrder();
    super.dispose();
  }

  void _loadDraftOrder() async {
    setState(() => _isLoading = true);
    final draftOrder = HiveService.getDraftOrder();
    if (draftOrder != null) {
      setState(() {
        _selectedProducts = draftOrder.products;
        _totalAmount = draftOrder.total;
        _customerController.text = draftOrder.customerName;
        _orderNumber = draftOrder.id;
      });
    } else {
      _generateOrderNumber();
    }
    setState(() => _isLoading = false);
  }

  void _saveDraftOrder() {
    if (_selectedProducts.isNotEmpty || _customerController.text.isNotEmpty) {
      final draftOrder = Order(
        id: _orderNumber,
        customerName:
            _customerController.text.isNotEmpty
                ? _customerController.text
                : 'Guest',
        products: _selectedProducts,
        total: _totalAmount,
        date: DateTime.now(),
      );
      HiveService.saveDraftOrder(draftOrder);
    }
  }

  void _generateOrderNumber() {
    setState(() {
      _orderNumber = 'INV-${DateTime.now().millisecondsSinceEpoch}';
    });
  }

  void _addProduct(Product product) {
    if (!_selectedProducts.any((item) => item['product'].id == product.id)) {
      setState(() {
        _selectedProducts.add({'product': product, 'quantity': 1});
        _calculateTotal();
      });
    }
  }

  void _updateQuantity(Product product, int change) {
    setState(() {
      final existing = _selectedProducts.firstWhere(
        (item) => item['product'].id == product.id,
        orElse: () => {'product': product, 'quantity': 0},
      );
      int newQuantity = existing['quantity'] + change;
      if (newQuantity < 0) newQuantity = 0;
      if (newQuantity > existing['product'].stockQuantity) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Only ${existing['product'].stockQuantity} available!',
            ),
          ),
        );
        return;
      }
      if (newQuantity == 0) {
        _selectedProducts.removeWhere(
          (item) => item['product'].id == product.id,
        );
      } else {
        existing['quantity'] = newQuantity;
      }
      _calculateTotal();
    });
  }

  void _removeProduct(Product product) {
    setState(() {
      _selectedProducts.removeWhere((item) => item['product'].id == product.id);
      _calculateTotal();
    });
  }

  void _calculateTotal() {
    setState(() {
      _totalAmount = _selectedProducts.fold(
        0.0,
        (sum, item) => sum + (item['product'].sellingPrice * item['quantity']),
      );
    });
  }

  void _saveOrder() async {
    if (_selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add at least one product.")),
      );
      return;
    }

    final order = Order(
      id: _orderNumber,
      customerName:
          _customerController.text.isNotEmpty
              ? _customerController.text
              : "Guest",
      products: _selectedProducts,
      total: _totalAmount,
      date: DateTime.now(),
      templateId: _selectedTemplateId, // Save selected template ID with the order
    );

    await HiveService.saveOrder(order);
    await HiveService.clearDraftOrder();

    // Show receipt dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Order Receipt"),
          content: SingleChildScrollView(
            child: _buildReceiptWidget(order, _selectedTemplateId),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Order saved successfully!")));
    setState(() {
      _selectedProducts = [];
      _totalAmount = 0.0;
      _generateOrderNumber();
      _customerController.clear();
    });
  }

  Widget _buildReceiptWidget(Order order, int? templateId) {
    switch (templateId) {
      case 0:
        return ReceiptTemplate1(order: order);
      case 1:
        return ReceiptTemplate2(order: order);
      case 2:
        return ReceiptTemplate3(order: order);
      case 3:
        return ReceiptTemplate4(order: order);
      default:
        return ReceiptTemplate1(order: order); // Default to template 1
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(AppSpacing.medium(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create New Order',
                  style: AppFonts.appBarTitle.copyWith(
                    fontSize: MediaQuery.of(context).size.width * 0.016,
                  ),
                ),
                SizedBox(height: AppSpacing.medium(context)),
                Row(
                  children: [
                    Expanded(
                      child: Autocomplete<Product>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<Product>.empty();
                          }
                          final products = HiveService.getProducts();
                          return products.where((Product product) {
                            return product.name.toLowerCase().contains(
                                  textEditingValue.text.toLowerCase(),
                                ) ||
                                product.sku != null &&
                                    product.sku!.toLowerCase().contains(
                                      textEditingValue.text.toLowerCase(),
                                    );
                          });
                        },
                        displayStringForOption: (Product option) => option.name,
                        fieldViewBuilder: (
                          BuildContext context,
                          TextEditingController textEditingController,
                          FocusNode focusNode,
                          VoidCallback onFieldSubmitted,
                        ) {
                          _searchController.text =
                              textEditingController
                                  .text; // Keep our controller in sync
                          return TextField(
                            controller: textEditingController,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              labelText: 'Search by SKU or Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            onSubmitted: (value) {
                              onFieldSubmitted();
                            },
                          );
                        },
                        onSelected: (Product selection) {
                          _addProduct(selection);
                          _searchController.clear();
                        },
                      ),
                    ),
                    SizedBox(width: AppSpacing.medium(context)),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: Text('Add Customer'),
                                content: TextField(
                                  controller: _customerController,
                                  decoration: InputDecoration(
                                    labelText: 'Customer Name',
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Save'),
                                  ),
                                ],
                              ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Add Customer'),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.medium(context)),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      border: TableBorder.all(color: Colors.grey),
                      columnSpacing: AppSpacing.small(context),
                      columns: [
                        DataColumn(label: Text('Sr')),
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Quantity')),
                        DataColumn(label: Text('Unit Price')),
                        DataColumn(label: Text('Total Price')),
                        DataColumn(label: Text('Action')),
                      ],
                      rows:
                          _selectedProducts.asMap().entries.map((entry) {
                            final index = entry.key + 1;
                            final item = entry.value;
                            final product = item['product'] as Product;
                            final quantity = item['quantity'] as int;
                            final total = product.sellingPrice * quantity;
                            return DataRow(
                              cells: [
                                DataCell(Text('$index')),
                                DataCell(Text(product.name)),
                                DataCell(Text('$quantity')),
                                DataCell(
                                  Text(
                                    '\$${product.sellingPrice.toStringAsFixed(2)}',
                                  ),
                                ),
                                DataCell(Text('\$${total.toStringAsFixed(2)}')),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: Colors.green,
                                        ),
                                        onPressed:
                                            () => _updateQuantity(product, 1),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.remove,
                                          color: Colors.red,
                                        ),
                                        onPressed:
                                            () => _updateQuantity(product, -1),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.grey,
                                        ),
                                        onPressed:
                                            () => _removeProduct(product),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.medium(context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Total: \$${_totalAmount.toStringAsFixed(2)}',
                      style: AppFonts.bodyText.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.014,
                      ),
                    ),
                    SizedBox(width: AppSpacing.medium(context)),
                    ElevatedButton(
                      onPressed: _saveOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Save'),
                    ),
                    SizedBox(width: AppSpacing.medium(context)),
                    ElevatedButton(
                      onPressed: () {
                        // Placeholder for print logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Print functionality to be implemented!',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Print'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
  }
}
