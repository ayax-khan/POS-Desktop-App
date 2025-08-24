// lib/core/services/navigation_service.dart
import 'package:flutter/material.dart';
import '../constants/navigation_constants.dart';

/// Singleton service for handling navigation throughout the app
/// 
/// This service provides a centralized way to handle navigation between
/// different screens in the POS application. It uses a callback pattern
/// to communicate with the main navigation screen.
/// 
/// Usage:
/// ```dart
/// final navigationService = NavigationService();
/// navigationService.navigateToNewSale();
/// ```
class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  // Callback function to handle navigation
  Function(String)? _onNavigate;

  /// Set the navigation callback function
  /// 
  /// This should be called from the main navigation screen to establish
  /// the connection between the service and the actual navigation logic.
  /// 
  /// [callback] - Function that takes a navigation key and handles the navigation
  void setNavigationCallback(Function(String) callback) {
    _onNavigate = callback;
    debugPrint('NavigationService: Navigation callback set successfully');
  }

  /// Navigate to a specific feature using navigation key
  /// 
  /// [feature] - Navigation key from NavigationConstants
  void navigateTo(String feature) {
    if (!NavigationConstants.isValidNavigationKey(feature)) {
      debugPrint('NavigationService: Invalid navigation key: $feature');
      return;
    }

    if (_onNavigate != null) {
      debugPrint('NavigationService: Navigating to $feature');
      _onNavigate!(feature);
    } else {
      debugPrint('NavigationService: Navigation callback not set. Cannot navigate to $feature');
    }
  }

  // Quick action navigation methods with clear documentation
  
  /// Navigate to Invoice screen for creating a new sale
  void navigateToNewSale() => navigateTo(NavigationConstants.invoice);
  
  /// Navigate to Products screen for adding/managing products
  void navigateToAddProduct() => navigateTo(NavigationConstants.products);
  
  /// Navigate to Reports screen for viewing analytics and reports
  void navigateToViewReports() => navigateTo(NavigationConstants.reports);
  
  /// Navigate to Customer screen for managing customers
  void navigateToManageCustomers() => navigateTo(NavigationConstants.customers);
  
  /// Navigate to Home screen (dashboard)
  void navigateToHome() => navigateTo(NavigationConstants.home);
  
  /// Navigate to Settings screen
  void navigateToSettings() => navigateTo(NavigationConstants.settings);

  /// Check if navigation service is properly initialized
  bool get isInitialized => _onNavigate != null;

  /// Clear the navigation callback (useful for testing or cleanup)
  void clearCallback() {
    _onNavigate = null;
    debugPrint('NavigationService: Navigation callback cleared');
  }
}

