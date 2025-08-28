import 'package:flutter/material.dart';
import 'package:pos/features/auth/services/auth_service.dart';
import 'package:pos/features/invoice/model/order.dart';
import 'package:pos/features/auth/models/business_info_model.dart';
import 'dart:io';

class ReceiptTemplate1 extends StatefulWidget {
  final Order order;

  const ReceiptTemplate1({super.key, required this.order});

  @override
  State<ReceiptTemplate1> createState() => _ReceiptTemplate1State();
}

class _ReceiptTemplate1State extends State<ReceiptTemplate1> {
  BusinessInfoModel? _businessInfo;

  @override
  void initState() {
    super.initState();
    _loadBusinessInfo();
  }

  Future<void> _loadBusinessInfo() async {
    try {
      final businessInfo = await AuthService().getBusinessInfo();
      if (mounted) {
        setState(() {
          _businessInfo = businessInfo;
        });
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Widget _buildBusinessHeader() {
    if (_businessInfo == null) {
      return const Center(
        child: Text(
          'BuyToEnjoy',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Column(
      children: [
        // Business Logo
        if (_businessInfo!.logoPath != null &&
            _businessInfo!.logoPath!.isNotEmpty)
          Container(
            width: 80,
            height: 80,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(_businessInfo!.logoPath!),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.business, size: 40);
                },
              ),
            ),
          ),
        // Business Name
        Text(
          _businessInfo!.shopName,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        // Business Address
        Text(
          _businessInfo!.address,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        // Business Phone
        Text(
          'Phone: ${_businessInfo!.phoneNumber}',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        // Business Country
        Text(
          _businessInfo!.country,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBusinessHeader(),
            Center(
              child: Text(
                'Date: ${widget.order.date.toLocal().toString().split(' ')[0]}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            const Divider(),
            Text('Order ID: ${widget.order.id}'),
            Text('Customer: ${widget.order.customerName}'),
            const SizedBox(height: 10),
            const Text(
              'Order Details:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Table(
              border: TableBorder.all(),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
                4: FlexColumnWidth(1),
              },
              children: [
                const TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Sr',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Item',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Qty',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Price',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Total',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                ...widget.order.products.asMap().entries.map((entry) {
                  final index = entry.key + 1;
                  final item = entry.value;
                  final product = item['product'];
                  final quantity = item['quantity'];
                  final total = product.sellingPrice * quantity;
                  return TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('$index'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(product.name),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('$quantity'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '\$${product.sellingPrice.toStringAsFixed(2)}',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('\$${total.toStringAsFixed(2)}'),
                      ),
                    ],
                  );
                }),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Grand Total: \$${widget.order.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
