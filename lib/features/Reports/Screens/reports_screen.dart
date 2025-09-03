// lib/features/Reports/Screens/reports_screen.dart
import 'package:flutter/material.dart';
import 'package:pos/core/constraints/colors.dart';
import 'package:pos/core/constraints/fonts.dart';
import 'package:pos/core/constraints/spacing.dart';
import 'package:pos/features/Reports/Services/reports_service.dart';
import 'package:pos/features/Reports/Models/revenue_data.dart';
import 'package:pos/features/Reports/Widgets/metric_card.dart';
import 'package:pos/features/Reports/Widgets/revenue_chart.dart';
import 'package:pos/features/Reports/Widgets/top_customers_widget.dart';
import 'package:pos/features/Reports/Widgets/top_products_widget.dart';
import 'package:pos/features/Reports/Widgets/sales_insights_widget.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedPeriod = 'Yesterday';
  String _selectedComparison = 'By product';
  bool _isLoading = true;
  RevenueData? _revenueData;
  DateTime? _customStartDate;
  DateTime? _customEndDate;

  final List<String> _periods = [
    'Today',
    'Yesterday',
    'Last Week',
    'Last Month',
    'Custom Date',
  ];
  final List<String> _comparisons = [
    'By product',
    'By customer',
    'By category',
    'By time',
  ];

  @override
  void initState() {
    super.initState();
    _loadRevenueData();
  }

  Future<void> _loadRevenueData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await ReportsService.getRevenueData(_selectedPeriod);
      setState(() {
        _revenueData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading data: $e')));
    }
  }

  Future<void> _selectCustomDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange:
          _customStartDate != null && _customEndDate != null
              ? DateTimeRange(start: _customStartDate!, end: _customEndDate!)
              : null,
    );

    if (picked != null) {
      setState(() {
        _customStartDate = picked.start;
        _customEndDate = picked.end;
        _selectedPeriod = 'Custom Date';
      });
      _loadRevenueData();
    }
  }

  Future<void> _downloadReport() async {
    try {
      final filePath = await ReportsService.exportRevenueReport(
        _revenueData!,
        _selectedPeriod,
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Report downloaded: $filePath')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error downloading report: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.medium(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            SizedBox(height: AppSpacing.medium(context)),
            if (_isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (_revenueData != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildKeyMetrics(),
                      SizedBox(height: AppSpacing.large(context)),
                      _buildRevenueChart(),
                      SizedBox(height: AppSpacing.large(context)),
                      _buildBottomSection(),
                    ],
                  ),
                ),
              )
            else
              const Expanded(child: Center(child: Text('No data available'))),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text('Revenue', style: AppFonts.appBarTitle),
          ],
        ),
        Row(
          children: [
            _buildDropdown(_selectedPeriod, _periods, (value) {
              setState(() {
                _selectedPeriod = value!;
              });
              _loadRevenueData();
            }),
            SizedBox(width: AppSpacing.medium(context)),
            _buildDropdown(_selectedComparison, _comparisons, (value) {
              setState(() {
                _selectedComparison = value!;
              });
              _loadRevenueData();
            }),
            SizedBox(width: AppSpacing.medium(context)),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Compare feature coming soon')),
                );
              },
              child: const Text('Compare'),
            ),
            SizedBox(width: AppSpacing.medium(context)),
            ElevatedButton.icon(
              onPressed: _downloadReport,
              icon: const Icon(Icons.download, color: Colors.orange),
              label: const Text(
                'Download',
                style: TextStyle(color: Colors.orange),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.withOpacity(0.1),
                elevation: 0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String value,
    List<String> items,
    void Function(String?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items:
              items.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
          onChanged: (String? newValue) {
            if (newValue == 'Custom Date') {
              _selectCustomDateRange();
            } else {
              onChanged(newValue);
            }
          },
        ),
      ),
    );
  }

  Widget _buildKeyMetrics() {
    if (_revenueData == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Metrics',
          style: AppFonts.bodyText.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(height: AppSpacing.medium(context)),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: MetricCard(
                title: 'Revenue',
                value: 'PKR${_revenueData!.totalRevenue.toStringAsFixed(2)}',
                previousDayChange: _revenueData!.revenuePreviousDayChange,
                weekOverWeekChange: _revenueData!.revenueWeekOverWeekChange,
                showCheckIcon: true,
              ),
            ),
            SizedBox(width: AppSpacing.medium(context)),
            Expanded(
              flex: 2,
              child: MetricCard(
                title: 'Returns',
                value: '${_revenueData!.returnRate.toStringAsFixed(2)}%',
                previousDayChange: _revenueData!.returnsPreviousDayChange,
                weekOverWeekChange: _revenueData!.returnsWeekOverWeekChange,
                showCheckIcon: false,
              ),
            ),
            Expanded(flex: 1, child: SizedBox()), // Spacer
          ],
        ),
      ],
    );
  }

  Widget _buildRevenueChart() {
    if (_revenueData == null) return const SizedBox();

    return SizedBox(
      height: 300,
      child: RevenueChart(
        revenueData: _revenueData!.chartData,
        visitorsData: _revenueData!.visitorsData,
      ),
    );
  }

  Widget _buildBottomSection() {
    if (_revenueData == null) return const SizedBox();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              SalesInsightsWidget(
                bestSalesDay: _revenueData!.bestSalesDay,
                peakSaleHour: _revenueData!.peakSaleHour,
                peakSaleAmount: _revenueData!.peakSaleAmount,
                lowStockCount: _revenueData!.lowStockCount,
              ),
            ],
          ),
        ),
        SizedBox(width: AppSpacing.large(context)),
        Expanded(
          child: Column(
            children: [
              TopCustomersWidget(customers: _revenueData!.topCustomers),
              SizedBox(height: AppSpacing.large(context)),
              TopProductsWidget(products: _revenueData!.topProducts),
            ],
          ),
        ),
      ],
    );
  }
}
