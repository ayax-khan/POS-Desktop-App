import 'package:flutter/material.dart';
import 'package:pos/core/constraints/fonts.dart';
import 'package:pos/core/constraints/spacing.dart';

class Template1 extends StatelessWidget {
  const Template1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.medium(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('[Business Logo]', style: AppFonts.bodyText),
              Text('Invoice #INV-1001', style: AppFonts.bodyText),
            ],
          ),
          Text(
            'Your Business Name',
            style: AppFonts.bodyText.copyWith(fontWeight: FontWeight.bold),
          ),
          Text('Address', style: AppFonts.bodyText),
          Text('GSTIN: 22AAAAA0000A1Z5', style: AppFonts.bodyText),
          SizedBox(height: AppSpacing.medium(context)),
          Text(
            'Sold To:',
            style: AppFonts.bodyText.copyWith(fontWeight: FontWeight.bold),
          ),
          Text('Customer Name', style: AppFonts.bodyText),
          Text('Address (optional)', style: AppFonts.bodyText),
          Text('GSTIN (if applicable)', style: AppFonts.bodyText),
          SizedBox(height: AppSpacing.medium(context)),
          Table(
            border: TableBorder.all(),
            columnWidths: const {
              0: FlexColumnWidth(0.5),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(1),
              5: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                children: [
                  Text('S.No', style: AppFonts.bodyText),
                  Text('Item', style: AppFonts.bodyText),
                  Text('Qty', style: AppFonts.bodyText),
                  Text('Price', style: AppFonts.bodyText),
                  Text('Tax %', style: AppFonts.bodyText),
                  Text('Amount', style: AppFonts.bodyText),
                ],
              ),
              TableRow(
                children: [
                  Text('1.', style: AppFonts.bodyText),
                  Text('Product A', style: AppFonts.bodyText),
                  Text('2', style: AppFonts.bodyText),
                  Text('500', style: AppFonts.bodyText),
                  Text('18%', style: AppFonts.bodyText),
                  Text('1000', style: AppFonts.bodyText),
                ],
              ),
            ],
          ),
          SizedBox(height: AppSpacing.medium(context)),
          Text('Subtotal: ₹1000', style: AppFonts.bodyText),
          Text('CGST 9%: ₹90', style: AppFonts.bodyText),
          Text('SGST 9%: ₹90', style: AppFonts.bodyText),
          Text('Round Off: ₹0', style: AppFonts.bodyText),
          Text(
            '**Total: ₹1180**',
            style: AppFonts.bodyText.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            'Payment: Cash ₹1200 | Change Due: ₹20',
            style: AppFonts.bodyText,
          ),
          Text(
            'Terms: No returns/exchange without original receipt',
            style: AppFonts.bodyText,
          ),
          Text('Thank you for your business!', style: AppFonts.bodyText),
        ],
      ),
    );
  }
}
