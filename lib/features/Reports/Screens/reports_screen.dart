import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos/core/constraints/colors.dart';
import 'package:pos/core/constraints/fonts.dart';
import 'package:pos/core/constraints/spacing.dart';
import 'package:pos/features/Reports/Services/reports_service.dart';
import 'package:pos/features/Reports/Models/revenue_data.dart';
import 'package:pos/features/Reports/Widgets/metric_card.dart';
import 'package:pos/features/Reports/Widgets/revenue_chart.dart';
import 'package:pos/features/Reports/Widgets/top_customers_widget.dart';
import 'package:pos/features/Reports/Widgets/top_products_widget.dart';
import 'package:pos/features/Reports/Widgets/hourly_revenue_widget.dart';
import 'package:pos/features/Reports/Widgets/sales_insights_widget.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedPeriod = 'Today';
  bool _isLoading = true;
  RevenueData? _revenueData;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _previousSelectedPeriod;
  Set<String> _selectedMetrics = {'Revenue'};

  final List<String> _periods = [
    'Today',
    'Yesterday',
    'Last Week',
    'Last Month',
    'Custom',
  ];

  @override
  void initState() {
    super.initState();
    _initializeReportsService();
  }

  Future<void> _initializeReportsService() async {
    try {
      await ReportsService.init();
      await ReportsService.addSampleOrders(); // demo data
      _loadRevenueData();
    } catch (e) {
      setState(() {
        // _revenueData=Data;
        _isLoading = false;
      });
      _showErrorMessage('Error initializing reports: $e');
    }
  }

  Future<void> _loadRevenueData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final data = await ReportsService.getRevenueData(
        period: _selectedPeriod,
        startDate: _startDate,
        endDate: _endDate,
      );
      setState(() {
        // Fixed: Added outer parentheses for method call
        _revenueData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorMessage('Error loading data: $e');
    }
  }

  Future<void> _downloadReport() async {
    if (_revenueData == null) return;
    try {
      final filePath = await ReportsService.exportRevenueReport(
        _revenueData!,
        _selectedPeriod,
      );
      _showSuccessMessage('Report downloaded: $filePath');
    } catch (e) {
      _showErrorMessage('Error downloading report: $e');
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _getCustomDateRangeText() {
    if (_startDate != null && _endDate != null) {
      final formatter = DateFormat('MMM dd, yyyy');
      return '${formatter.format(_startDate!)} - ${formatter.format(_endDate!)}';
    }
    return 'Custom';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        padding: EdgeInsets.all(AppSpacing.medium(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: AppSpacing.medium(context)),

            // Loading
            if (_isLoading)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.blue,
                        strokeWidth: 3,
                      ),
                      SizedBox(height: AppSpacing.medium(context)),
                      Text(
                        'Loading reports data...',
                        style: AppFonts.bodyText.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            // Data available
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
            // No data
            else
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      SizedBox(height: AppSpacing.medium(context)),
                      Text(
                        'No data available for this period',
                        style: AppFonts.heading.copyWith(
                          color: Colors.grey.shade500,
                        ),
                      ),
                      SizedBox(height: AppSpacing.small(context)),
                      ElevatedButton(
                        onPressed: _loadRevenueData,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Reports Dashboard', style: AppFonts.appBarTitle),
        Expanded(child: SizedBox()),
        _buildPeriodDropdown(),
        SizedBox(width: AppSpacing.medium(context)),
        _buildHeaderActions(),
      ],
    );
  }

  Widget _buildPeriodDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: _selectedPeriod,
        underline: SizedBox(),
        items:
            _periods.map((period) {
              final displayText =
                  period == 'Custom' ? _getCustomDateRangeText() : period;
              return DropdownMenuItem<String>(
                value: period,
                child: Text(
                  displayText,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              );
            }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            _onPeriodSelected(newValue);
          }
        },
      ),
    );
  }

  Widget _buildHeaderActions() {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: _revenueData != null ? _downloadReport : null,
          icon: const Icon(Icons.download, color: Colors.orange),
          label: const Text('Download', style: TextStyle(color: Colors.orange)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange.withOpacity(0.1),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Future<void> _onPeriodSelected(String period) async {
    if (period == 'Custom') {
      _previousSelectedPeriod = _selectedPeriod;
      final DateTimeRange? range = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
        initialDateRange:
            _startDate != null && _endDate != null
                ? DateTimeRange(start: _startDate!, end: _endDate!)
                : null,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.blue,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          );
        },
      );
      if (range != null) {
        setState(() {
          _startDate = range.start;
          _endDate = range.end;
          _selectedPeriod = period;
        });
        _loadRevenueData();
      } else {
        setState(() {
          _selectedPeriod = _previousSelectedPeriod!;
        });
      }
    } else {
      setState(() {
        _selectedPeriod = period;
        _startDate = null;
        _endDate = null;
      });
      _loadRevenueData();
    }
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
            fontSize: 16,
          ),
        ),
        SizedBox(height: AppSpacing.medium(context)),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _toggleMetric('Revenue'),
                child: MetricCard(
                  title: 'Revenue',
                  value: 'PKR ${_revenueData!.totalRevenue.toStringAsFixed(0)}',
                  previousDayChange: _revenueData!.revenuePreviousDayChange,
                  weekOverWeekChange: _revenueData!.revenueWeekOverWeekChange,
                  showCheckIcon: true,
                ),
              ),
            ),
            SizedBox(width: AppSpacing.medium(context)),
            Expanded(
              child: GestureDetector(
                onTap: () => _toggleMetric('Products'),
                child: MetricCard(
                  title: 'Products Sold',
                  value: _revenueData!.totalProducts.toString(),
                  previousDayChange: _revenueData!.productsPreviousDayChange,
                  weekOverWeekChange: _revenueData!.productsWeekOverWeekChange,
                  showCheckIcon: true,
                ),
              ),
            ),
            SizedBox(width: AppSpacing.medium(context)),
            Expanded(
              child: GestureDetector(
                onTap: () => _toggleMetric('Customers'),
                child: MetricCard(
                  title: 'Customers',
                  value: _revenueData!.totalCustomers.toString(),
                  previousDayChange: _revenueData!.customersPreviousDayChange,
                  weekOverWeekChange: _revenueData!.customersWeekOverWeekChange,
                  showCheckIcon: true,
                ),
              ),
            ),
            SizedBox(width: AppSpacing.medium(context)),
            Expanded(
              child: MetricCard(
                title: 'Return Rate',
                value: '${_revenueData!.returnRate.toStringAsFixed(1)}%',
                previousDayChange: _revenueData!.returnsPreviousDayChange,
                weekOverWeekChange: _revenueData!.returnsWeekOverWeekChange,
                showCheckIcon: false,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _toggleMetric(String metric) {
    setState(() {
      if (_selectedMetrics.contains(metric)) {
        _selectedMetrics.remove(metric);
      } else {
        _selectedMetrics.add(metric);
      }
      if (_selectedMetrics.isEmpty) {
        _selectedMetrics.add('Revenue');
      }
    });
  }

  Widget _buildRevenueChart() {
    if (_revenueData == null) return const SizedBox();
    return RevenueChart(
      revenueData: _revenueData!.chartData,
      visitorsData: _revenueData!.visitorsData,
      productsData: _revenueData!.productsData,
      selectedMetrics: _selectedMetrics,
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
              HourlyRevenueWidget(hourlyData: _revenueData!.hourlyRevenue),
              SizedBox(height: AppSpacing.large(context)),
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
