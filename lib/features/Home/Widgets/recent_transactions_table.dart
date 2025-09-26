import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos/core/constants/receipt_dialog.dart';
import 'package:pos/core/services/hive_service.dart';
import 'package:pos/features/Home/Models/dashboard_data.dart';
import 'package:pos/features/invoice/model/order.dart';

class RecentTransactionsTable extends StatefulWidget {
  final List<RecentTransaction> transactions;

  const RecentTransactionsTable({super.key, required this.transactions});

  @override
  State<RecentTransactionsTable> createState() =>
      _RecentTransactionsTableState();
}

class _RecentTransactionsTableState extends State<RecentTransactionsTable> {
  int _currentPage = 0;
  final int _itemsPerPage = 10;
  bool _showAll = false;

  void viewReceipt(BuildContext context, RecentTransaction transaction) {
    final order = HiveService.getOrders().cast<Order?>().firstWhere(
      (o) => o?.id == transaction.id,
      orElse: () => null,
    );
    if (order != null) {
      showDialog(
        context: context,
        builder: (context) => ReceiptDialog(order: order),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.transactions.length;
    final displayedTransactions =
        _showAll
            ? widget.transactions
            : widget.transactions
                .skip(_currentPage * _itemsPerPage)
                .take(_itemsPerPage)
                .toList();
    final start = _currentPage * _itemsPerPage + 1;
    final end = min(start + _itemsPerPage - 1, total);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Row(
                  children: [
                    if (!_showAll) ...[
                      Text('$start-$end of $total'),
                      IconButton(
                        icon: const Icon(Icons.chevron_left, size: 16),
                        onPressed:
                            _currentPage > 0
                                ? () => setState(() => _currentPage--)
                                : null,
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right, size: 16),
                        onPressed:
                            end < total
                                ? () => setState(() => _currentPage++)
                                : null,
                      ),
                    ],
                    TextButton.icon(
                      onPressed: () => setState(() => _showAll = !_showAll),
                      icon: Icon(
                        _showAll ? Icons.arrow_upward : Icons.arrow_forward,
                        size: 16,
                      ),
                      label: Text(_showAll ? 'Collapse' : 'View All'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
              columns: const [
                DataColumn(label: Text('Invoice ID')),
                DataColumn(label: Text('Customer')),
                DataColumn(label: Text('Amount')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Payment')),
                DataColumn(label: Text('Actions')),
              ],
              rows:
                  displayedTransactions.map((transaction) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(
                            transaction.id,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        DataCell(Text(transaction.customerName)),
                        DataCell(
                          Text(
                            '\$${transaction.amount.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        DataCell(_buildStatusChip(transaction.status)),
                        DataCell(
                          Text(
                            DateFormat('MMM dd, yyyy').format(transaction.date),
                          ),
                        ),
                        DataCell(_buildPaymentChip(transaction.paymentMethod)),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.visibility_outlined,
                                  size: 18,
                                ),
                                onPressed:
                                    () => viewReceipt(context, transaction),
                                tooltip: 'View',
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.print_outlined,
                                  size: 18,
                                ),
                                onPressed: () {},
                                tooltip: 'Print',
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    Color bgColor;

    switch (status.toLowerCase()) {
      case 'completed':
        color = Colors.green;
        bgColor = Colors.green.shade50;
        break;
      case 'pending':
        color = Colors.orange;
        bgColor = Colors.orange.shade50;
        break;
      case 'cancelled':
        color = Colors.red;
        bgColor = Colors.red.shade50;
        break;
      default:
        color = Colors.grey;
        bgColor = Colors.grey.shade50;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPaymentChip(String method) {
    IconData icon;
    switch (method.toLowerCase()) {
      case 'card':
        icon = Icons.credit_card;
        break;
      case 'cash':
        icon = Icons.money;
        break;
      case 'transfer':
        icon = Icons.account_balance;
        break;
      default:
        icon = Icons.payment;
    }

    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(
          method,
          style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
        ),
      ],
    );
  }
}
