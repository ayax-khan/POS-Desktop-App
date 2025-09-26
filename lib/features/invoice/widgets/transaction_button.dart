import 'package:flutter/material.dart';
import 'package:pos/core/constants/receipt_dialog.dart';
import 'package:pos/core/constraints/fonts.dart';
import 'package:pos/core/constraints/spacing.dart';
import 'package:pos/core/services/hive_service.dart';
import 'package:pos/features/invoice/model/order.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  List<Map<String, dynamic>> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() async {
    setState(() => _isLoading = true);
    _transactions = HiveService.getTransactions();
    // Sort transactions by date in descending order (most recent first)
    _transactions.sort((a, b) {
      final dateA = DateTime.parse(a['date'] as String);
      final dateB = DateTime.parse(b['date'] as String);
      return dateB.compareTo(dateA);
    });
    setState(() => _isLoading = false);
  }

  void viewReceipt(String orderId) {
    final order = HiveService.getOrders().cast<Order?>().firstWhere(
      (o) => o?.id == orderId,
      orElse: () => null,
    );
    if (order != null) {
      showDialog(
        context: context,
        builder: (context) => ReceiptDialog(order: order),
      );
    }
  }

  void _deleteTransaction(String orderId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text(
              'Are you sure you want to delete this transaction?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      await HiveService.deleteOrder(orderId);
      _loadTransactions(); // Reload transactions after deletion
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction deleted successfully!')),
      );
    }
  }

  String _getTemplateName(int templateId) {
    switch (templateId) {
      case 0:
        return 'Classic';
      case 1:
        return 'Modern';
      case 2:
        return 'Minimal';
      case 3:
        return 'Colorful';
      default:
        return 'Classic';
    }
  }

  Color _getTemplateColor(int templateId) {
    switch (templateId) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.teal;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Container(
          padding: EdgeInsets.all(AppSpacing.medium(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Transaction History',
                style: AppFonts.appBarTitle.copyWith(
                  fontSize: MediaQuery.of(context).size.width * 0.016,
                ),
              ),
              SizedBox(height: AppSpacing.medium(context)),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical, // Ensure vertical scrolling
                  child: SizedBox(
                    width: AppSpacing.width(
                      context,
                      0.8,
                    ), // Set explicit width for the DataTable
                    child: DataTable(
                      border: TableBorder.all(
                        color: Colors.black,
                      ), // Add all borders
                      columnSpacing: AppSpacing.small(context),
                      // Adjust minWidth to increase table width
                      dataRowMinHeight: 48.0,
                      dataRowMaxHeight: 60.0,
                      horizontalMargin: 12.0,
                      showCheckboxColumn: false,
                      headingRowHeight: 56.0,
                      columns: [
                        DataColumn(
                          label: Text(
                            'Sr',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Order ID',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Customer',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Total',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Template',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Date',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Action',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      rows:
                          _transactions.asMap().entries.map((entry) {
                            final index = entry.key + 1;
                            final transaction = entry.value;
                            // Get the full order to access templateId
                            final order = HiveService.getOrders()
                                .cast<Order?>()
                                .firstWhere(
                                  (o) => o?.id == transaction['orderId'],
                                  orElse: () => null,
                                );
                            final templateId = order?.templateId ?? 0;
                            final templateName = _getTemplateName(templateId);

                            return DataRow(
                              key: ValueKey(transaction['orderId']),
                              cells: [
                                DataCell(Text(index.toString())),
                                DataCell(Text(transaction['orderId'] ?? 'N/A')),
                                DataCell(
                                  Text(transaction['customerName'] ?? 'Guest'),
                                ),
                                DataCell(
                                  Text(
                                    '\$${(transaction['total'] as double).toStringAsFixed(2)}',
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getTemplateColor(templateId),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      templateName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    (transaction['date'] as String).split(
                                      '.',
                                    )[0],
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.visibility,
                                          color: Colors.blue,
                                        ),
                                        onPressed:
                                            () => viewReceipt(
                                              transaction['orderId'] as String,
                                            ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.print,
                                          color: Colors.purple,
                                        ),
                                        onPressed: () {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Print functionality to be implemented!',
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed:
                                            () => _deleteTransaction(
                                              transaction['orderId'] as String,
                                            ),
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
              ),
            ],
          ),
        );
  }
}
