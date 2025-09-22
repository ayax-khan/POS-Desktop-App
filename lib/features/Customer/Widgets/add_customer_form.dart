import 'package:flutter/material.dart';
import 'package:ulid/ulid.dart';
import '../Models/customer_model.dart';
import '../../../core/constraints/spacing.dart';

class AddCustomerForm extends StatefulWidget {
  final Function(Customer) onSave;
  final Customer? customer;

  const AddCustomerForm({super.key, required this.onSave, this.customer});

  @override
  State<AddCustomerForm> createState() => _AddCustomerFormState();
}

class _AddCustomerFormState extends State<AddCustomerForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _notesController;
  String _selectedGroup = 'All customers';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer?.name ?? '');
    _emailController = TextEditingController(
      text: widget.customer?.email ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.customer?.phone ?? '',
    );
    _notesController = TextEditingController(
      text: widget.customer?.notes ?? '',
    );
    if (widget.customer?.group != null) {
      _selectedGroup = widget.customer!.group;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final customer = Customer(
        id: widget.customer?.id ?? Ulid().toString(),
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        group: _selectedGroup,
        notes: _notesController.text,
        lastVisited: widget.customer?.lastVisited,
        createdAt: widget.customer?.createdAt ?? DateTime.now(),
      );
      widget.onSave(customer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name *',
                  hintText: 'Enter customer name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter customer name';
                  }
                  return null;
                },
              ),
              SizedBox(height: AppSpacing.height(context, 0.015)),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email *',
                  hintText: 'Enter customer email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter customer email';
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: AppSpacing.height(context, 0.015)),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone *',
                  hintText: 'Enter customer phone',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter customer phone';
                  }
                  return null;
                },
              ),
              SizedBox(height: AppSpacing.height(context, 0.015)),
              DropdownButtonFormField<String>(
  value: _selectedGroup, // <-- corrected
  decoration: const InputDecoration(labelText: 'Group'),
  items: <String>[
    'All customers',
    'VIP',
    'New',
    'Regular',
  ].map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList(),
  onChanged: (String? newValue) {
    setState(() {
      _selectedGroup = newValue!;
    });
  },
),
              SizedBox(height: AppSpacing.height(context, 0.015)),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  hintText: 'Enter any additional information',
                ),
                maxLines: 3,
              ),
              SizedBox(height: AppSpacing.height(context, 0.015)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  SizedBox(width: AppSpacing.large(context)),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(
                      widget.customer == null
                          ? 'Add Customer'
                          : 'Update Customer',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
