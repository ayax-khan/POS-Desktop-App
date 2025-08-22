import 'package:flutter/material.dart';
import 'package:pos/core/constraints/fonts.dart';
import 'package:pos/core/constraints/spacing.dart';
import 'package:pos/features/invoice/receipt_templates/receipt_template_1.dart';
import 'package:pos/features/invoice/receipt_templates/receipt_template_2.dart';
import 'package:pos/features/invoice/receipt_templates/receipt_template_3.dart';
import 'package:pos/features/invoice/receipt_templates/receipt_template_4.dart';
import 'package:pos/features/invoice/model/dummy_order.dart';

class InvoiceTemplates extends StatelessWidget {
  final int? selectedTemplate;
  final Function(int) onTemplateSelected;

  const InvoiceTemplates({
    super.key,
    required this.selectedTemplate,
    required this.onTemplateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.medium(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Receipt Template',
            style: AppFonts.appBarTitle.copyWith(
              fontSize: MediaQuery.of(context).size.width * 0.016,
            ),
          ),
          SizedBox(height: AppSpacing.medium(context)),
          Expanded(
            child: SingleChildScrollView(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.medium(context),
                mainAxisSpacing: AppSpacing.medium(context),
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), // GridView won't scroll; parent SingleChildScrollView handles it
                children: [
                  _buildTemplateContainer(context, 0, ReceiptTemplate1(order: createDummyOrder())),
                  _buildTemplateContainer(context, 1, ReceiptTemplate2(order: createDummyOrder())),
                  _buildTemplateContainer(context, 2, ReceiptTemplate3(order: createDummyOrder())),
                  _buildTemplateContainer(context, 3, ReceiptTemplate4(order: createDummyOrder())),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateContainer(
    BuildContext context,
    int index,
    Widget template,
  ) {
    return GestureDetector(
      onTap: () => onTemplateSelected(index),
      child: Container(
        width: AppSpacing.width(context, 0.22),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Transform.scale(
                scale: 0.3, // Scale down the template for preview
                child: template,
              ),
            ),
            if (selectedTemplate == index)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: MediaQuery.of(context).size.width * 0.02,
                  ),
                ),
              ),
            // Template name overlay
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getTemplateName(index),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTemplateName(int index) {
    switch (index) {
      case 0:
        return 'Classic';
      case 1:
        return 'Modern';
      case 2:
        return 'Minimal';
      case 3:
        return 'Colorful';
      default:
        return 'Template ${index + 1}';
    }
  }
}
