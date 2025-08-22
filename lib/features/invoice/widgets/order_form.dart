import 'package:flutter/material.dart';
import 'package:pos/core/constraints/colors.dart';
import 'package:pos/core/constraints/fonts.dart';
import 'package:pos/core/constraints/spacing.dart';
import 'package:pos/core/models/products.dart';
import 'package:pos/core/services/hive_service.dart';

class OrderForm extends StatefulWidget {
  final Function(Product, int) onAddProduct;
  final Function(Product, int) onUpdateQuantity;
  final Function(Product) onRemoveProduct;

  const OrderForm({
    super.key,
    required this.onAddProduct,
    required this.onUpdateQuantity,
    required this.onRemoveProduct,
  });

  @override
  State<OrderForm> createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  List<Product> _products = [];
  Product? _selectedProduct;
  int _quantity = 1;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() async {
    setState(() => _isLoading = true);
    _products = HiveService.getProducts();
    setState(() => _isLoading = false);
  }

  void _addToOrder() {
    if (_selectedProduct != null && _quantity > 0) {
      widget.onAddProduct(_selectedProduct!, _quantity);
      setState(() {
        _selectedProduct = null;
        _quantity = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.medium(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customer Information',
                  style: AppFonts.bodyText.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.014,
                  ),
                ),
                SizedBox(height: AppSpacing.medium(context)),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Customer Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                SizedBox(height: AppSpacing.medium(context)),
                Text(
                  'Select Product',
                  style: AppFonts.bodyText.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.014,
                  ),
                ),
                SizedBox(height: AppSpacing.small(context)),
                Row(
                  children: [
                    Expanded(
                      child: Autocomplete<Product>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          return _products.where(
                            (product) => product.name.toLowerCase().contains(
                              textEditingValue.text.toLowerCase(),
                            ),
                          );
                        },
                        displayStringForOption: (Product option) => option.name,
                        onSelected: (Product selection) {
                          setState(() => _selectedProduct = selection);
                        },
                      ),
                    ),
                    SizedBox(width: AppSpacing.medium(context)),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Quantity',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        onChanged: (value) {
                          setState(() {
                            _quantity = int.tryParse(value) ?? 1;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: AppSpacing.medium(context)),
                    ElevatedButton(
                      onPressed: _addToOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Add Product'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
  }
}
