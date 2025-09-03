import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pos/features/invoice/model/order.dart';
import 'package:pos/features/auth/services/auth_service.dart';
import 'package:pos/features/auth/models/business_info_model.dart';

class ReceiptTemplate2 extends StatefulWidget {
  final Order order;

  const ReceiptTemplate2({super.key, required this.order});

  @override
  State<ReceiptTemplate2> createState() => _ReceiptTemplate2State();
}

class _ReceiptTemplate2State extends State<ReceiptTemplate2> {
  BusinessInfoModel? _businessInfo;

  @override
  void initState() {
    super.initState();
    _loadBusinessInfo();
  }

  Future<void> _loadBusinessInfo() async {
    try {
      final authService = AuthService();
      final businessInfo = await authService.getBusinessInfo();
      setState(() {
        _businessInfo = businessInfo;
      });
    } catch (e) {
      // Handle error
    }
  }

  Widget _buildBusinessHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade600,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          if (_businessInfo?.logoPath != null)
            Container(
              height: 60,
              width: 60,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: FileImage(File(_businessInfo!.logoPath!)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Text(
            _businessInfo?.shopName ?? 'BuyToEnjoy',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _businessInfo?.address ?? 'Your Business Address',
            style: const TextStyle(fontSize: 14, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          if (_businessInfo?.phoneNumber != null)
            Text(
              'Phone: ${_businessInfo!.phoneNumber}',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          if (_businessInfo?.country != null)
            Text(
              _businessInfo!.country!,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBusinessHeader(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order ID: ${widget.order.id}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Customer: ${widget.order.customerName}'),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'PAID',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Order Details:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Sr',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Item',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Qty',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Price',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Total',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...widget.order.products.asMap().entries.map((entry) {
                    final index = entry.key + 1;
                    final item = entry.value;
                    final product = item['product'];
                    final quantity = item['quantity'];
                    final total = product.sellingPrice * quantity;
                    return Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(flex: 1, child: Text('$index')),
                          Expanded(flex: 3, child: Text(product.name)),
                          Expanded(flex: 1, child: Text('$quantity')),
                          Expanded(
                            flex: 1,
                            child: Text(
                              '\$${product.sellingPrice.toStringAsFixed(2)}',
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text('\$${total.toStringAsFixed(2)}'),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue.shade600,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Grand Total: \$${widget.order.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
