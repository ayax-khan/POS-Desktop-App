import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos/core/constraints/colors.dart';
import 'package:pos/core/constraints/fonts.dart';
import 'package:pos/core/constraints/spacing.dart';
import 'package:pos/core/models/products.dart';
import 'package:ulid/ulid.dart';
import '../../../core/services/hive_service.dart';

class AddProductForm extends StatefulWidget {
  final VoidCallback onProductAdded;
  final Product? productToEdit;

  const AddProductForm({
    super.key,
    required this.onProductAdded,
    this.productToEdit,
  });

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _skuController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _stockQuantityController = TextEditingController();
  final _unitController = TextEditingController();
  final _brandController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _taxController = TextEditingController();
  final _supplierInfoController = TextEditingController();
  final _discountController = TextEditingController();
  final _reorderLevelController = TextEditingController();
  DateTime? _expiryDate;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    if (widget.productToEdit != null) {
      final product = widget.productToEdit!;
      _nameController.text = product.name;
      _categoryController.text = product.category;
      _skuController.text = product.sku ?? '';
      _purchasePriceController.text = product.purchasePrice.toString();
      _sellingPriceController.text = product.sellingPrice.toString();
      _stockQuantityController.text = product.stockQuantity.toString();
      _unitController.text = product.unit;
      _brandController.text = product.brand ?? '';
      _barcodeController.text = product.barcode ?? '';
      _descriptionController.text = product.description ?? '';
      _taxController.text = product.tax?.toString() ?? '';
      _supplierInfoController.text = product.supplierInfo ?? '';
      _discountController.text = product.discount?.toString() ?? '';
      _reorderLevelController.text = product.reorderLevel?.toString() ?? '';
      _expiryDate = product.expiryDate;
      _imagePath = product.imagePath;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _skuController.dispose();
    _purchasePriceController.dispose();
    _sellingPriceController.dispose();
    _stockQuantityController.dispose();
    _unitController.dispose();
    _brandController.dispose();
    _barcodeController.dispose();
    _descriptionController.dispose();
    _taxController.dispose();
    _supplierInfoController.dispose();
    _discountController.dispose();
    _reorderLevelController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _imagePath = result.files.single.path;
      });
    }
  }

  Future<void> _pickExpiryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _expiryDate = picked;
      });
    }
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: widget.productToEdit?.id ?? Ulid().toString(),
        name: _nameController.text,
        category: _categoryController.text,
        purchasePrice: double.parse(_purchasePriceController.text),
        sellingPrice: double.parse(_sellingPriceController.text),
        stockQuantity: int.parse(_stockQuantityController.text),
        unit: _unitController.text,
        brand: _brandController.text.isNotEmpty ? _brandController.text : null,
        sku: _skuController.text.isNotEmpty ? _skuController.text : null,
        barcode:
            _barcodeController.text.isNotEmpty ? _barcodeController.text : null,
        expiryDate: _expiryDate,
        imagePath: _imagePath,
        description:
            _descriptionController.text.isNotEmpty
                ? _descriptionController.text
                : null,
        tax:
            _taxController.text.isNotEmpty
                ? double.parse(_taxController.text)
                : null,
        supplierInfo:
            _supplierInfoController.text.isNotEmpty
                ? _supplierInfoController.text
                : null,
        discount:
            _discountController.text.isNotEmpty
                ? double.parse(_discountController.text)
                : null,
        reorderLevel:
            _reorderLevelController.text.isNotEmpty
                ? int.parse(_reorderLevelController.text)
                : null,
      );

      (widget.productToEdit == null
              ? HiveService.addProduct(product)
              : HiveService.updateProduct(product))
          .then((_) {
            widget.onProductAdded();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  widget.productToEdit == null
                      ? 'Product added successfully!'
                      : 'Product updated successfully!',
                ),
              ),
            );
            Navigator.of(context).pop();
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: EdgeInsets.all(AppSpacing.large(context)),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5, // 50% of screen width
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.productToEdit == null ? 'Add Product' : 'Edit Product',
                  style: AppFonts.appBarTitle,
                ),
                SizedBox(height: AppSpacing.large(context)),
                _buildSectionTitle('Basic Information'),
                _buildTextField(
                  _nameController,
                  'Product Name',
                  required: true,
                ),
                _buildTextField(
                  _categoryController,
                  'Category',
                  required: true,
                ),
                _buildTextField(
                  _skuController,
                  'SKU/Product Code',
                  required: true,
                ),
                _buildTextField(_brandController, 'Brand (Optional)'),
                _buildTextField(_barcodeController, 'Barcode (Optional)'),
                _buildSectionTitle('Pricing'),
                _buildTextField(
                  _purchasePriceController,
                  'Purchase Price',
                  required: true,
                  keyboardType: TextInputType.number,
                ),
                _buildTextField(
                  _sellingPriceController,
                  'Selling Price',
                  required: true,
                  keyboardType: TextInputType.number,
                ),
                _buildTextField(
                  _taxController,
                  'Tax (%) (Optional)',
                  keyboardType: TextInputType.number,
                ),
                _buildTextField(
                  _discountController,
                  'Discount (Optional)',
                  keyboardType: TextInputType.number,
                ),
                _buildSectionTitle('Inventory'),
                _buildTextField(
                  _stockQuantityController,
                  'Stock Quantity',
                  required: true,
                  keyboardType: TextInputType.number,
                ),
                _buildTextField(
                  _unitController,
                  'Unit (e.g., pcs, kg)',
                  required: true,
                ),
                _buildTextField(
                  _reorderLevelController,
                  'Reorder Level (Optional)',
                  keyboardType: TextInputType.number,
                ),
                _buildDateField(
                  'Expiry Date (Optional)',
                  _expiryDate,
                  _pickExpiryDate,
                ),
                _buildSectionTitle('Additional Information'),
                _buildTextField(
                  _supplierInfoController,
                  'Supplier Info (Optional)',
                  maxLines: 2,
                ),
                _buildTextField(
                  _descriptionController,
                  'Description/Notes (Optional)',
                  maxLines: 3,
                ),
                _buildImagePicker(),
                SizedBox(height: AppSpacing.large(context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: AppFonts.bodyText.copyWith(
                          color: AppColors.secondary,
                          fontSize: MediaQuery.of(context).size.width * 0.01,
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacing.medium(context)),
                    ElevatedButton(
                      onPressed: _saveProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.large(context),
                          vertical: AppSpacing.medium(context),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        widget.productToEdit == null
                            ? 'Save Product'
                            : 'Update Product',
                        style: AppFonts.bodyText.copyWith(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.01,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.medium(context)),
      child: Text(
        title,
        style: AppFonts.bodyText.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
          fontSize: MediaQuery.of(context).size.width * 0.012,
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool required = false,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.medium(context)),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.white,
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator:
            required
                ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter $label';
                  }
                  return null;
                }
                : null,
        style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.01),
      ),
    );
  }

  Widget _buildDateField(String label, DateTime? date, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.medium(context)),
      child: InkWell(
        onTap: onTap,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.white,
          ),
          child: Text(
            date != null
                ? DateFormat('dd/MM/yyyy').format(date)
                : 'Select date',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.01,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.medium(context)),
      child: Row(
        children: [
          Expanded(
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Product Image (Optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              child: Text(
                _imagePath ?? 'No image selected',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.01,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.medium(context)),
          ElevatedButton(
            onPressed: _pickImage,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Pick Image',
              style: AppFonts.bodyText.copyWith(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width * 0.01,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
