import 'package:flutter/material.dart';
import 'package:pos/features/invoice/model/order.dart';

class ReceiptTemplate3 extends StatelessWidget {
  final Order order;

  const ReceiptTemplate3({super.key, required this.order});

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
            Column(
              children: [
                const Text(
                  'BUYTOENJOY',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 4.0,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Container(height: 1, width: 200, color: Colors.black87),
                const SizedBox(height: 8),
                Text(
                  order.date.toLocal().toString().split(' ')[0],
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Order info in clean rows
            _buildInfoRow('ORDER ID', order.id),
            _buildInfoRow('CUSTOMER', order.customerName.toUpperCase()),

            const SizedBox(height: 32),

            // Items header
            const Text(
              'ITEMS',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 2.0,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Items list with clean spacing
            ...order.products.asMap().entries.map((entry) {
              final index = entry.key + 1;
              final item = entry.value;
              final product = item['product'];
              final quantity = item['quantity'];
              final total = product.sellingPrice * quantity;

              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${index.toString().padLeft(2, '0')}. ${product.name.toUpperCase()}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        Text(
                          '\$${total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const SizedBox(width: 24), // Indent for details
                        Text(
                          'QTY: $quantity × \$${product.sellingPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(height: 1, color: Colors.grey.shade200),
                  ],
                ),
              );
            }),

            const SizedBox(height: 16),

            // Total section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.black87, width: 2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'TOTAL',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2.0,
                    ),
                  ),
                  Text(
                    '\$${order.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                letterSpacing: 1.0,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
