import 'package:flutter/material.dart';
import 'package:pos/features/invoice/model/order.dart';

class ReceiptTemplate1 extends StatelessWidget {
  final Order order;

  const ReceiptTemplate1({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'BuyToEnjoy',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                'Date: ${order.date.toLocal().toString().split(' ')[0]}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            const Divider(),
            Text('Order ID: ${order.id}'),
            Text('Customer: ${order.customerName}'),
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
                ...order.products.asMap().entries.map((entry) {
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
                'Grand Total: \$${order.total.toStringAsFixed(2)}',
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
