import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pos/features/invoice/model/order.dart';
import 'package:pos/features/auth/services/auth_service.dart';
import 'package:pos/features/auth/models/business_info_model.dart';

class ReceiptTemplate3 extends StatefulWidget {
  final Order order;

  const ReceiptTemplate3({super.key, required this.order});

  @override
  State<ReceiptTemplate3> createState() => _ReceiptTemplate3State();
}

class _ReceiptTemplate3State extends State<ReceiptTemplate3> {
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
    return Column(
      children: [
        if (_businessInfo?.logoPath != null)
          Container(
            height: 50,
            width: 50,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              image: DecorationImage(
                image: FileImage(File(_businessInfo!.logoPath!)),
                fit: BoxFit.cover,
              ),
            ),
          ),
        Text(
          (_businessInfo?.shopName ?? 'BUYTOENJOY').toUpperCase(),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w300,
            letterSpacing: 4.0,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Container(height: 1, width: 200, color: Colors.black87),
        const SizedBox(height: 8),
        if (_businessInfo?.address != null)
          Text(
            _businessInfo!.address!,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
              letterSpacing: 1.0,
            ),
            textAlign: TextAlign.center,
          ),
        if (_businessInfo?.phoneNumber != null)
          Text(
            'Phone: ${_businessInfo!.phoneNumber}',
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
              letterSpacing: 1.0,
            ),
          ),
        if (_businessInfo?.country != null)
          Text(
            _businessInfo!.country!,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
              letterSpacing: 1.0,
            ),
          ),
        Text(
          widget.order.date.toLocal().toString().split(' ')[0],
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 2),
        borderRadius: BorderRadius.circular(
          0,
        ), // Sharp corners for minimalist look
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with clean typography
            _buildBusinessHeader(),
            const SizedBox(height: 32),
            // Order info with minimal styling
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ORDER ${widget.order.id}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2.0,
                  ),
                ),
                Text(
                  widget.order.customerName.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(height: 1, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            // Items list with clean layout
            ...widget.order.products.asMap().entries.map((entry) {
              final index = entry.key + 1;
              final item = entry.value;
              final product = item['product'];
              final quantity = item['quantity'];
              final total = product.sellingPrice * quantity;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      child: Text(
                        '$index.',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      child: Text(
                        '$quantity',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: Text(
                        '\$${product.sellingPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),
            Container(height: 1, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            // Total with emphasis
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TOTAL',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 3.0,
                  ),
                ),
                Text(
                  '\$${widget.order.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Footer
            const Center(
              child: Text(
                'THANK YOU',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 2.0,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
