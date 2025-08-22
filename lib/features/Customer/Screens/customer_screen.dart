import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pos/core/constraints/spacing.dart';
import 'package:pos/features/Customer/Models/customer_model.dart';
import 'package:pos/features/Customer/Widgets/add_customer_form.dart';
import 'package:pos/features/Customer/Widgets/customer_button_toolbar.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  List<Customer> _customers = [];
  String _currentGroup = "All customers";
  final TextEditingController _searchController = TextEditingController();
  bool _isAllSelected = false;
  final List<Customer> _selectedCustomers = [];

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    final customerBox = await Hive.openBox<Customer>('customers');
    setState(() {
      _customers = customerBox.values.toList();
    });
  }

  void _deleteSelectedCustomers() async {
    final customerBox = await Hive.openBox<Customer>('customers');
    for (var customer in _selectedCustomers) {
      await customerBox.delete(customer.id);
    }
    _selectedCustomers.clear();
    _loadCustomers();
  }

  void _showAddCustomerDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add New Customer'),
            content: AddCustomerForm(
              onSave: (Customer customer) {
                _saveCustomer(customer);
                Navigator.of(context).pop();
              },
            ),
          ),
    );
  }

  Future<void> _saveCustomer(Customer customer) async {
    final customerBox = await Hive.openBox<Customer>('customers');
    await customerBox.put(customer.id, customer);
    _loadCustomers();
  }

  void _toggleSelectAll(bool? value) {
    setState(() {
      _isAllSelected = value ?? false;
      _selectedCustomers.clear();
      if (_isAllSelected) {
        _selectedCustomers.addAll(_customers);
      }
    });
  }

  void _toggleSelectCustomer(bool? selected, Customer customer) {
    setState(() {
      if (selected == true) {
        _selectedCustomers.add(customer);
      } else {
        _selectedCustomers.remove(customer);
      }
      _isAllSelected = _selectedCustomers.length == _customers.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Directory'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PopupMenuButton(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    const Text('Import / Export'),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      child: const Text('Import Customers'),
                      onTap: () {
                        // Import functionality
                      },
                    ),
                    PopupMenuItem(
                      child: const Text('Export Customers'),
                      onTap: () {
                        // Export functionality
                      },
                    ),
                  ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PopupMenuButton(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    const Text('Send campaign'),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      child: const Text('Email Campaign'),
                      onTap: () {
                        // Email campaign functionality
                      },
                    ),
                    PopupMenuItem(
                      child: const Text('SMS Campaign'),
                      onTap: () {
                        // SMS campaign functionality
                      },
                    ),
                  ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              onPressed: _showAddCustomerDialog,
              child: const Text('Create'),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(AppSpacing.medium(context)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Group: ',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    DropdownButton<String>(
                      value: _currentGroup,
                      icon: const Icon(Icons.arrow_drop_down),
                      onChanged: (String? newValue) {
                        setState(() {
                          _currentGroup = newValue!;
                        });
                      },
                      items:
                          <String>[
                            'All customers',
                            'VIP',
                            'New',
                            'Regular',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.info_outline, size: 16),
                  ],
                ),
                Row(
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Create group'),
                      onPressed: () {
                        // Create new group functionality
                      },
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      child: const Text('Filters'),
                      onPressed: () {
                        // Filter functionality
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.small(context),
              vertical: AppSpacing.extraSmall(context),
            ),
            child: Row(
              children: [
                Checkbox(value: _isAllSelected, onChanged: _toggleSelectAll),
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      const Text(
                        'Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Email',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Phone',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Last Visited',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 48), // For add button
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: _customers.length,
              itemBuilder: (context, index) {
                final customer = _customers[index];
                final isSelected = _selectedCustomers.contains(customer);

                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.small(context),
                        vertical: AppSpacing.extraSmall(context),
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: isSelected,
                            onChanged:
                                (selected) =>
                                    _toggleSelectCustomer(selected, customer),
                          ),
                          Expanded(flex: 3, child: Text(customer.name)),
                          Expanded(flex: 3, child: Text(customer.email)),
                          Expanded(flex: 2, child: Text(customer.phone)),
                          Expanded(
                            flex: 2,
                            child: Text(customer.lastVisited ?? 'Never'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, size: 20),
                            onPressed: () {
                              // Add functionality
                            },
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          _selectedCustomers.isNotEmpty
              ? CustomerButtonToolbar(
                selectedCount: _selectedCustomers.length,
                onDelete: _deleteSelectedCustomers,
              )
              : null,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
