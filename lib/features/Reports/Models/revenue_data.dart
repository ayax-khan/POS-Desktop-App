// lib/features/Reports/Models/revenue_data.dart
class RevenueData {
  final double totalRevenue;
  final int totalProducts;
  final int totalCustomers;
  final double returnRate;

  // Change percentages
  final double revenuePreviousDayChange;
  final double revenueWeekOverWeekChange;
  final double productsPreviousDayChange;
  final double productsWeekOverWeekChange;
  final double customersPreviousDayChange;
  final double customersWeekOverWeekChange;
  final double returnsPreviousDayChange;
  final double returnsWeekOverWeekChange;

  // Chart data
  final List<ChartDataPoint> chartData;
  final List<ChartDataPoint> visitorsData;

  // Lists
  final List<TopCustomer> topCustomers;
  final List<TopProduct> topProducts;
  final List<HourlyRevenue> hourlyRevenue;

  // Insights
  final String bestSalesDay;
  final String peakSaleHour;
  final double peakSaleAmount;
  final int lowStockCount;

  RevenueData({
    required this.totalRevenue,
    required this.totalProducts,
    required this.totalCustomers,
    required this.returnRate,
    required this.revenuePreviousDayChange,
    required this.revenueWeekOverWeekChange,
    required this.productsPreviousDayChange,
    required this.productsWeekOverWeekChange,
    required this.customersPreviousDayChange,
    required this.customersWeekOverWeekChange,
    required this.returnsPreviousDayChange,
    required this.returnsWeekOverWeekChange,
    required this.chartData,
    required this.visitorsData,
    required this.topCustomers,
    required this.topProducts,
    required this.hourlyRevenue,
    required this.bestSalesDay,
    required this.peakSaleHour,
    required this.peakSaleAmount,
    required this.lowStockCount,
  });
}

class ChartDataPoint {
  final DateTime date;
  final double value;

  ChartDataPoint({required this.date, required this.value});
}

class TopCustomer {
  final String name;
  final double amount;

  TopCustomer({required this.name, required this.amount});
}

class TopProduct {
  final String name;
  final int units;
  final double amount;
  final String? sku;

  TopProduct({
    required this.name,
    required this.units,
    required this.amount,
    this.sku,
  });
}

class HourlyRevenue {
  final String hour;
  final double amount;

  HourlyRevenue({required this.hour, required this.amount});
}
