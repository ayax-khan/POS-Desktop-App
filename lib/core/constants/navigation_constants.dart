// lib/core/constants/navigation_constants.dart

/// Navigation constants for consistent navigation throughout the app
class NavigationConstants {
  // Private constructor to prevent instantiation
  NavigationConstants._();

  // Navigation keys for different screens
  static const String home = 'Home';
  static const String products = 'Products';
  static const String customers = 'Customer';
  static const String invoice = 'Invoice';
  static const String reports = 'Reports';
  static const String settings = 'Settings';

  // Quick action navigation mappings
  static const Map<String, String> quickActionMappings = {
    'newSale': invoice,
    'addProduct': products,
    'viewReports': reports,
    'manageCustomers': customers,
  };

  // Get all available navigation keys
  static List<String> get allNavigationKeys => [
        home,
        products,
        customers,
        invoice,
        reports,
        settings,
      ];

  // Validate if a navigation key is valid
  static bool isValidNavigationKey(String key) {
    return allNavigationKeys.contains(key);
  }
}

