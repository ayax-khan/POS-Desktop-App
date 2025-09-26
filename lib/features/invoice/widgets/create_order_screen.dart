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
  final TextEditingController _customerController = TextEditingController();

  TextEditingController? autoCompleteController;
  FocusNode? autoCompleteFocusNode;

  List<Map<String, dynamic>> _selectedProducts = [];
  double _totalAmount = 0.0;
  bool _isLoading = true;
  String _orderNumber = "";
  int? _selectedTemplateId;

  @override
  void initState() {
    super.initState();
    _selectedTemplateId = widget.selectedTemplate ?? 0;
    _loadDraftOrder();
    _generateOrderNumber();
  }

  @override
  void didUpdateWidget(CreateOrderScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedTemplate != widget.selectedTemplate) {
      setState(() {
        _selectedTemplateId = widget.selectedTemplate ?? 0;
      });
    }
  }

  @override
  void dispose() {
    _saveDraftOrder();
    _customerController.dispose();
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
      final existingIndex = _selectedProducts.indexWhere(
        (item) => item['product'].id == product.id,
      );
      if (existingIndex == -1) return;

      final existing = _selectedProducts[existingIndex];
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
        _selectedProducts.removeAt(existingIndex);
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
    _totalAmount = _selectedProducts.fold(
      0.0,
      (sum, item) => sum + (item['product'].sellingPrice * item['quantity']),
    );
    setState(() {});
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
      templateId: _selectedTemplateId,
    );

    await HiveService.saveOrder(order);
    await HiveService.clearDraftOrder();

    _showReceiptDialog(order);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Order saved successfully!")));

    _resetOrder();
  }

  void _showReceiptDialog(Order order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Order Receipt"),
          insetPadding: const EdgeInsets.all(20),
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: _buildReceiptWidget(order, _selectedTemplateId),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReceiptWidget(Order order, int? templateId) {
    final templates = [
      ReceiptTemplate1(order: order),
      ReceiptTemplate2(order: order),
      ReceiptTemplate3(order: order),
      ReceiptTemplate4(order: order),
    ];
    return templates[templateId ?? 0];
  }

  void _resetOrder() {
    setState(() {
      _selectedProducts.clear();
      _totalAmount = 0.0;
      _generateOrderNumber();
      _customerController.clear();
    });
  }

  void _showCustomerDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Customer'),
            content: TextField(
              controller: _customerController,
              decoration: const InputDecoration(labelText: 'Customer Name'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  Widget _buildProductSearchField() {
    return Autocomplete<Product>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<Product>.empty();
        }
        final products = HiveService.getProducts();
        return products.where(
          (product) =>
              product.name.toLowerCase().contains(
                textEditingValue.text.toLowerCase(),
              ) ||
              (product.sku != null &&
                  product.sku!.toLowerCase().contains(
                    textEditingValue.text.toLowerCase(),
                  )),
        );
      },
      displayStringForOption: (Product option) => option.name,
      fieldViewBuilder: (
        BuildContext context,
        TextEditingController textEditingController,
        FocusNode focusNode,
        VoidCallback onFieldSubmitted,
      ) {
        autoCompleteController = textEditingController;
        autoCompleteFocusNode = focusNode;
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: 'Search by SKU or Name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.grey[100],
          ),
          onSubmitted: (value) {
            onFieldSubmitted();
            textEditingController.clear();
            focusNode.requestFocus();
          },
        );
      },
      optionsViewBuilder: (
        BuildContext context,
        AutocompleteOnSelected<Product> onSelected,
        Iterable<Product> options,
      ) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final product = options.elementAt(index);
                  return _buildProductSuggestionItem(
                    context,
                    product,
                    onSelected,
                  );
                },
              ),
            ),
          ),
        );
      },
      onSelected: (Product selection) {
        _addProduct(selection);
        autoCompleteController?.clear();
        Future.delayed(Duration.zero, () {
          autoCompleteFocusNode?.requestFocus();
        });
      },
    );
  }

  Widget _buildProductSuggestionItem(
    BuildContext context,
    Product product,
    AutocompleteOnSelected<Product> onSelected,
  ) {
    bool isHovered = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (event) => setState(() => isHovered = true),
          onExit: (event) => setState(() => isHovered = false),
          child: InkWell(
            onTap: () {
              onSelected(product);
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    isHovered
                        ? const Color.fromARGB(255, 252, 238, 233)
                        : Colors.white,
                border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.inventory_2,
                                  size: 15,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade700,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'SKU: ${product.sku ?? 'N/A'}',
                                  ),
                                  const TextSpan(text: ' | '),
                                  TextSpan(
                                    text: 'Stock: ${product.stockQuantity}',
                                  ),
                                  const TextSpan(text: ' | '),
                                  TextSpan(
                                    text:
                                        'Price: \$${product.sellingPrice.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductsTable() {
    if (_selectedProducts.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'No products added yet',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          border: TableBorder.all(color: Colors.grey),
          columnSpacing: AppSpacing.small(context),
          columns: const [
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
                      Text('\$${product.sellingPrice.toStringAsFixed(2)}'),
                    ),
                    DataCell(Text('\$${total.toStringAsFixed(2)}')),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.green),
                            onPressed: () => _updateQuantity(product, 1),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove, color: Colors.red),
                            onPressed: () => _updateQuantity(product, -1),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.grey),
                            onPressed: () => _removeProduct(product),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(AppSpacing.medium(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create New Order',
              style: AppFonts.appBarTitle.copyWith(
                fontSize: screenWidth * 0.016,
              ),
            ),
            SizedBox(height: AppSpacing.medium(context)),

            // Search and Customer Section
            Row(
              children: [
                Expanded(child: _buildProductSearchField()),
                SizedBox(width: AppSpacing.medium(context)),
                ElevatedButton(
                  onPressed: _showCustomerDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Add Customer',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),

            SizedBox(height: AppSpacing.medium(context)),

            // Products Table
            _buildProductsTable(),

            SizedBox(height: AppSpacing.medium(context)),

            // Total and Actions Section
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Total: \$${_totalAmount.toStringAsFixed(2)}',
                  style: AppFonts.bodyText.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.014,
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
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: AppSpacing.medium(context)),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Print functionality to be implemented!'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Print',
                    style: TextStyle(color: Colors.white),
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
