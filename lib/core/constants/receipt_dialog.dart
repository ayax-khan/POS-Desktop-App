// New file: lib/features/invoice/receipt_dialog.dart
import 'package:flutter/material.dart';
import 'package:pos/core/constraints/fonts.dart';
import 'package:pos/core/constraints/spacing.dart';
import 'package:pos/features/invoice/model/order.dart';
import 'package:pos/features/invoice/receipt_templates/receipt_template_1.dart';
import 'package:pos/features/invoice/receipt_templates/receipt_template_2.dart';
import 'package:pos/features/invoice/receipt_templates/receipt_template_3.dart';
import 'package:pos/features/invoice/receipt_templates/receipt_template_4.dart';

class ReceiptDialog extends StatelessWidget {
  final Order order;

  const ReceiptDialog({super.key, required this.order});

  Widget _buildReceiptWithTemplate(Order order) {
    // Use saved template ID, default to template 1 if none saved
    final templateId = order.templateId ?? 0;

    switch (templateId) {
      case 0:
        return ReceiptTemplate1(order: order);
      case 1:
        return ReceiptTemplate2(order: order);
      case 2:
        return ReceiptTemplate3(order: order);
      case 3:
        return ReceiptTemplate4(order: order);
      default:
        return ReceiptTemplate1(order: order); // Default fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          padding: EdgeInsets.all(AppSpacing.medium(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Receipt - ${order.id}',
                    style: AppFonts.appBarTitle.copyWith(
                      fontSize: MediaQuery.of(context).size.width * 0.014,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.medium(context)),
              // Display receipt using saved template
              _buildReceiptWithTemplate(order),
            ],
          ),
        ),
      ),
    );
  }
}
