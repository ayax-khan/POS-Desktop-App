import 'package:flutter/material.dart';
import 'package:pos/core/constraints/colors.dart';
import 'package:pos/core/constraints/fonts.dart';
import 'package:pos/core/constraints/spacing.dart';
import 'package:pos/features/invoice/widgets/create_order_screen.dart';
import 'package:pos/features/invoice/widgets/invoice_buttons.dart';
import 'package:pos/features/invoice/widgets/transaction_button.dart';
import 'package:pos/features/invoice/widgets/invoice_templates.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  int _selectedIndex = 0; // Default to Create Order screen (index 0)
  int? _selectedTemplate = 0; // Set default template to Classic (index 0)

  void _onButtonTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index != 2) {
        // Don't reset template when switching away from template screen
        // _selectedTemplate = null; 
      }
    });
  }

  void _selectTemplate(int templateIndex) {
    setState(() {
      _selectedTemplate = templateIndex;
      // Automatically switch back to Create Order screen after template selection
      _selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.background,
        padding: EdgeInsets.all(AppSpacing.medium(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invoice',
              style: AppFonts.appBarTitle.copyWith(
                fontSize: MediaQuery.of(context).size.width * 0.018,
              ),
            ),
            SizedBox(height: AppSpacing.medium(context)),
            Container(
              padding: EdgeInsets.all(
                AppSpacing.small(context),
              ), // Adjusted for responsiveness
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InvoiceButtons(
                    onCreateOrderTapped: () => _onButtonTapped(0),
                    onTransactionsTapped: () => _onButtonTapped(1),
                  ),
                  _buildTemplateButton(),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.medium(context)),
            Expanded(child: _buildSelectedScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return CreateOrderScreen(selectedTemplate: _selectedTemplate);
      case 1:
        return TransactionsScreen();
      case 2:
        return InvoiceTemplates(
          selectedTemplate: _selectedTemplate,
          onTemplateSelected: _selectTemplate,
        );
      default:
        return CreateOrderScreen(); // Fallback to Create Order
    }
  }

  Widget _buildTemplateButton() {
    return ElevatedButton.icon(
      onPressed: () => _onButtonTapped(2),
      icon: const Icon(Icons.format_list_bulleted, color: Colors.white),
      label: Text(
        'Templates',
        style: AppFonts.bodyText.copyWith(
          color: Colors.white,
          fontSize: MediaQuery.of(context).size.width * 0.01,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.medium(context),
          vertical: AppSpacing.small(context),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
      ),
    );
  }
}
