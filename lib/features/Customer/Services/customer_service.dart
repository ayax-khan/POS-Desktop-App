import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../Models/customer_model.dart';

class CustomerService {
  static const String _boxName = 'customers';

  // Initialize Hive and register adapter
  static Future<void> init() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(CustomerAdapter());
    }
    await Hive.openBox<Customer>(_boxName);
  }

  // Get all customers
  static Future<List<Customer>> getAllCustomers() async {
    final box = await Hive.openBox<Customer>(_boxName);
    return box.values.toList();
  }

  // Get customers by group
  static Future<List<Customer>> getCustomersByGroup(String group) async {
    if (group == 'All customers') {
      return getAllCustomers();
    }
    final box = await Hive.openBox<Customer>(_boxName);
    return box.values.where((customer) => customer.group == group).toList();
  }

  // Add a new customer
  static Future<void> addCustomer(Customer customer) async {
    final box = await Hive.openBox<Customer>(_boxName);
    await box.put(customer.id, customer);
  }

  // Update an existing customer
  static Future<void> updateCustomer(Customer customer) async {
    final box = await Hive.openBox<Customer>(_boxName);
    await box.put(customer.id, customer);
  }

  // Delete a customer
  static Future<void> deleteCustomer(String id) async {
    final box = await Hive.openBox<Customer>(_boxName);
    await box.delete(id);
  }

  // Delete multiple customers
  static Future<void> deleteCustomers(List<String> ids) async {
    final box = await Hive.openBox<Customer>(_boxName);
    for (var id in ids) {
      await box.delete(id);
    }
  }

  // Search customers by name, email, or phone
  static Future<List<Customer>> searchCustomers(String query) async {
    query = query.toLowerCase();
    final box = await Hive.openBox<Customer>(_boxName);
    return box.values.where((customer) {
      return customer.name.toLowerCase().contains(query) ||
          customer.email.toLowerCase().contains(query) ||
          customer.phone.toLowerCase().contains(query);
    }).toList();
  }

  // Export customers to CSV and return file path
  static Future<String> exportCustomersToCSV(List<Customer> customers) async {
    try {
      // Prepare data for CSV
      List<List<dynamic>> csvData = [];

      // Add headers
      csvData.add([
        'ID',
        'Customer Name',
        'Email',
        'Phone',
        'Group',
        'Notes',
        'Last Visited',
        'Created At',
      ]);

      // Add customer data
      for (var customer in customers) {
        csvData.add([
          customer.id,
          customer.name,
          customer.email,
          customer.phone,
          customer.group,
          customer.notes,
          customer.lastVisited,
          customer.createdAt,
        ]);
      }

      // Convert to CSV string
      String csv = const ListToCsvConverter().convert(csvData);

      // Get directory for saving file
      Directory directory = await getApplicationDocumentsDirectory();
      String filePath =
          '${directory.path}/customers_export_${DateTime.now().millisecondsSinceEpoch}.csv';

      // Write to file
      File file = File(filePath);
      await file.writeAsString(csv);

      return filePath;
    } catch (e) {
      debugPrint('Error exporting to CSV: $e');
      throw Exception('Failed to export CSV: $e');
    }
  }

  // Import customers from CSV file and return list of customers
  static Future<List<Customer>> importCustomersFromCSV(File csvFile) async {
    try {
      // Read CSV file
      String csvString = await csvFile.readAsString();

      // Parse CSV
      List<List<dynamic>> csvData = const CsvToListConverter().convert(
        csvString,
      );

      // Remove header row
      csvData.removeAt(0);

      List<Customer> customers = [];

      // Convert each row to Customer object
      for (var row in csvData) {
        try {
          customers.add(
            Customer(
              id: row[0].toString(),
              name: row[1].toString(),
              email: row[2].toString(),
              phone: row[3].toString(),
              group: row[4].toString(),
              notes: row[5].toString(),
              lastVisited: row[6].toString(),
              createdAt: DateTime.parse(row[7].toString()),
            ),
          );
        } catch (e) {
          debugPrint('Error parsing customer row: $row. Error: $e');
        }
      }

      return customers;
    } catch (e) {
      debugPrint('Error importing from CSV: $e');
      throw Exception('Failed to import CSV: $e');
    }
  }

  // Update customer's last visited date
  static Future<void> updateLastVisited(String id, String date) async {
    final box = await Hive.openBox<Customer>(_boxName);
    final customer = box.get(id);
    if (customer != null) {
      final updatedCustomer = customer.copyWith(lastVisited: date);
      await box.put(id, updatedCustomer);
    }
  }

  // Batch add customers (for import)
  static Future<void> batchAddCustomers(List<Customer> customers) async {
    final box = await Hive.openBox<Customer>(_boxName);
    final Map<String, Customer> customersMap = {};
    for (var customer in customers) {
      customersMap[customer.id] = customer;
    }
    await box.putAll(customersMap);
  }
}
