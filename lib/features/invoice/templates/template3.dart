import 'package:flutter/material.dart';
import 'package:pos/core/constraints/fonts.dart';
import 'package:pos/core/constraints/spacing.dart';

class Template3 extends StatelessWidget {
  const Template3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.medium(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🛍️ YOUR BRAND NAME',
            style: AppFonts.bodyText.copyWith(fontWeight: FontWeight.bold),
          ),
          Text('Where Quality Meets Style™', style: AppFonts.bodyText),
          Divider(color: Colors.black, thickness: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('🔖 Invoice: #BR-2023-105', style: AppFonts.bodyText),
              Text('🕒 15/06/23 • 2:30 PM', style: AppFonts.bodyText),
            ],
          ),
          Divider(color: Colors.black, thickness: 2),
          Text(
            '👤 Customer: John Doe (ID: CID-5582)',
            style: AppFonts.bodyText,
          ),
          Text(
            '📍 Delivery to: 123 Main St, Mumbai 400001',
            style: AppFonts.bodyText,
          ),
          Text(
            '📱 +91 98765 43210 • 🏷️ GSTIN: 22BBBBB0000B2Z6',
            style: AppFonts.bodyText,
          ),
          SizedBox(height: AppSpacing.medium(context)),
          Table(
            border: TableBorder.all(),
            columnWidths: const {
              0: FlexColumnWidth(3),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                children: [
                  Text('ITEM', style: AppFonts.bodyText),
                  Text('QTY', style: AppFonts.bodyText),
                  Text('RATE', style: AppFonts.bodyText),
                  Text('AMOUNT', style: AppFonts.bodyText),
                ],
              ),
              TableRow(
                children: [
                  Text('✔️ Premium Headphones', style: AppFonts.bodyText),
                  Text('1', style: AppFonts.bodyText),
                  Text('₹5,999', style: AppFonts.bodyText),
                  Text('₹5,999', style: AppFonts.bodyText),
                ],
              ),
              TableRow(
                children: [
                  Text('✔️ Ear cushions (pair)', style: AppFonts.bodyText),
                  Text('2', style: AppFonts.bodyText),
                  Text('₹399', style: AppFonts.bodyText),
                  Text('₹798', style: AppFonts.bodyText),
                ],
              ),
              TableRow(
                children: [
                  Text('✔️ 2Y Warranty', style: AppFonts.bodyText),
                  Text('1', style: AppFonts.bodyText),
                  Text('₹1,199', style: AppFonts.bodyText),
                  Text('₹1,199', style: AppFonts.bodyText),
                ],
              ),
            ],
          ),
          SizedBox(height: AppSpacing.medium(context)),
          Text('SUBTOTAL:                 ₹7,996', style: AppFonts.bodyText),
          Text('DISCOUNT (WELCOME10):    -₹800', style: AppFonts.bodyText),
          Text('GST (18%):               ₹1,295', style: AppFonts.bodyText),
          Text(
            '💎 TOTAL:                ₹8,491',
            style: AppFonts.bodyText.copyWith(fontWeight: FontWeight.bold),
          ),
          Text('💳 Paid via: UPI (Ref: 5T8H9K)', style: AppFonts.bodyText),
          Text(
            '★★★★★ Loyalty Points Earned: 85 ★★★★★',
            style: AppFonts.bodyText,
          ),
          Text('📦 Expected Delivery: 18-Jun-2023', style: AppFonts.bodyText),
          Text('📞 Customer Care: 1800-123-4567', style: AppFonts.bodyText),
          Text(
            'Thanks for choosing us! Scan QR for feedback:',
            style: AppFonts.bodyText,
          ),
          Text('[QR CODE]', style: AppFonts.bodyText),
          Divider(color: Colors.black, thickness: 2),
        ],
      ),
    );
  }
}
