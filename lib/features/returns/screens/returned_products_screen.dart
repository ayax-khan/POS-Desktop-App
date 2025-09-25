import 'package:flutter/material.dart';
import 'package:pos/core/constraints/colors.dart';
import 'package:pos/core/constraints/fonts.dart';
import 'package:pos/core/constraints/spacing.dart';
import 'package:pos/features/returns/models/returned_product_model.dart';
import 'package:pos/features/returns/services/returns_service.dart';
import 'package:intl/intl.dart';

class ReturnedProductsScreen extends StatefulWidget {
  const ReturnedProductsScreen({super.key});

  @override
  State<ReturnedProductsScreen> createState() => _ReturnedProductsScreenState();
}

class _ReturnedProductsScreenState extends State<ReturnedProductsScreen> {
  List<ReturnedProduct> _returnedProducts = [];
  String _selectedFilter = 'Today';
  bool _isLoading = true;
  Map<String, dynamic> _statistics = {};

  final List<String> _filterOptions = [
    'Today',
    'Yesterday',
    'Last Week',
    'Last Month',
    'Custom Date',
  ];

  @override
  void initState() {
    super.initState();
    _loadReturnedProducts();
    _loadStatistics();
  }

  Future<void> _loadReturnedProducts() async {
    setState(() => _isLoading = true);

    try {
      List<ReturnedProduct> products;

      switch (_selectedFilter) {
        case 'Today':
          products = await ReturnsService.getTodayReturns();
          break;
        case 'Yesterday':
          final yesterday = DateTime.now().subtract(const Duration(days: 1));
          final startOfDay = DateTime(
            yesterday.year,
            yesterday.month,
            yesterday.day,
          );
          final endOfDay = DateTime(
            yesterday.year,
            yesterday.month,
            yesterday.day,
            23,
            59,
            59,
          );
          products = await ReturnsService.getReturnsByDateRange(
            startOfDay,
            endOfDay,
          );
          break;
        case 'Last Week':
          products = await ReturnsService.getLastWeekReturns();
          break;
        case 'Last Month':
          products = await ReturnsService.getLastMonthReturns();
          break;
        default:
          products = await ReturnsService.getAllReturns();
      }

      setState(() {
        _returnedProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading returns: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _loadStatistics() async {
    final stats = await ReturnsService.getReturnStatistics();
    setState(() => _statistics = stats);
  }

  Future<void> _selectCustomDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 7)),
        end: DateTime.now(),
      ),
    );

    if (picked != null) {
      setState(() => _isLoading = true);

      try {
        final products = await ReturnsService.getReturnsByDateRange(
          picked.start,
          picked.end,
        );

        setState(() {
          _returnedProducts = products;
          _selectedFilter = 'Custom Date';
          _isLoading = false;
        });
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading custom date range: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildStatisticsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Returns',
            '${_statistics['totalReturns'] ?? 0}',
            Icons.assignment_return,
            Colors.blue,
          ),
        ),
        SizedBox(width: AppSpacing.medium(context)),
        Expanded(
          child: _buildStatCard(
            'Today Returns',
            '${_statistics['todayReturns'] ?? 0}',
            Icons.today,
            Colors.green,
          ),
        ),
        SizedBox(width: AppSpacing.medium(context)),
        Expanded(
          child: _buildStatCard(
            'Total Value',
            '\$${(_statistics['totalReturnValue'] ?? 0.0).toStringAsFixed(2)}',
            Icons.attach_money,
            Colors.orange,
          ),
        ),
        SizedBox(width: AppSpacing.medium(context)),
        Expanded(
          child: _buildStatCard(
            'Today Value',
            '\$${(_statistics['todayReturnValue'] ?? 0.0).toStringAsFixed(2)}',
            Icons.monetization_on,
            Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedFilter,
          icon: const Icon(Icons.arrow_drop_down),
          items:
              _filterOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() => _selectedFilter = newValue);
              if (newValue == 'Custom Date') {
                _selectCustomDateRange();
              } else {
                _loadReturnedProducts();
              }
            }
          },
        ),
      ),
    );
  }

  Widget _buildReturnsList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_returnedProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_return,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No returns found for $_selectedFilter',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              'Returns will appear here when products are returned',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.assignment_return, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Returned Products (${_returnedProducts.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                _buildFilterDropdown(),
              ],
            ),
          ),
          // Table Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Product',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'SKU',
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
                    'Amount',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Reason',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Date',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Status',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          // Table Body
          Expanded(
            child: ListView.builder(
              itemCount: _returnedProducts.length,
              itemBuilder: (context, index) {
                final returnItem = _returnedProducts[index];
                final isEven = index % 2 == 0;

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isEven ? Colors.white : Colors.grey.shade50,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              returnItem.productName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (returnItem.customerName != null)
                              Text(
                                'Customer: ${returnItem.customerName}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(returnItem.productSku ?? 'N/A'),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text('${returnItem.quantityReturned}'),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          '\$${returnItem.totalAmount.toStringAsFixed(2)}',
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          returnItem.reason,
                          style: const TextStyle(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          DateFormat('MMM dd').format(returnItem.returnDate),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: returnItem.status.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: returnItem.status.color.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            returnItem.status.displayName,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: returnItem.status.color,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.all(AppSpacing.small(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Returned Products', style: AppFonts.appBarTitle),
          SizedBox(height: AppSpacing.medium(context)),
          _buildStatisticsCards(),
          SizedBox(height: AppSpacing.medium(context)),
          Expanded(child: _buildReturnsList()),
        ],
      ),
    );
  }
}
