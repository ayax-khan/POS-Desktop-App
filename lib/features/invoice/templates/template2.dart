// import 'package:flutter/material.dart';
// import 'package:pos/core/constraints/fonts.dart';
// import 'package:pos/core/constraints/spacing.dart';

// class Template2 extends StatelessWidget {
//   const Template2({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(AppSpacing.medium(context)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: EdgeInsets.all(AppSpacing.small(context)),
//             decoration: BoxDecoration(border: Border.all(color: Colors.black)),
//             child: Column(
//               children: [
//                 Text('[Your Business Logo]', style: AppFonts.bodyText),
//                 Text(
//                   'INVOICE #INV-2023-105',
//                   style: AppFonts.bodyText.copyWith(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   'Date: 15-Jun-2023 • Time: 14:30',
//                   style: AppFonts.bodyText,
//                 ),
//               ],
//             ),
//           ),
//           Text(
//             '[Business Name]',
//             style: AppFonts.bodyText.copyWith(fontWeight: FontWeight.bold),
//           ),
//           Text(
//             '123 Business Street • City, State - PIN',
//             style: AppFonts.bodyText,
//           ),
//           Text(
//             '📞 +91 XXXX XXX XXX • ✉ hello@business.com',
//             style: AppFonts.bodyText,
//           ),
//           Text('GSTIN: 22AAAAA0000A1Z5', style: AppFonts.bodyText),
//           SizedBox(height: AppSpacing.medium(context)),
//           Text(
//             'TO:',
//             style: AppFonts.bodyText.copyWith(fontWeight: FontWeight.bold),
//           ),
//           Text('John Doe', style: AppFonts.bodyText),
//           Text('johndoe@email.com • +91 98765 43210', style: AppFonts.bodyText),
//           Text('GSTIN: (If applicable)', style: AppFonts.bodyText),
//           SizedBox(height: AppSpacing.medium(context)),
//           Table(
//             border: TableBorder.all(),
//             columnWidths: const {
//               0: FlexColumnWidth(1),
//               1: FlexColumnWidth(3),
//               2: FlexColumnWidth(1),
//               3: FlexColumnWidth(1),
//               4: FlexColumnWidth(1),
//             },
//             children: [
//               TableRow(
//                 children: [
//                   Text('ITEM', style: AppFonts.bodyText),
//                   Text('DESCRIPTION', style: AppFonts.bodyText),
//                   Text('QTY', style: AppFonts.bodyText),
//                   Text('PRICE', style: AppFonts.bodyText),
//                   Text('TOTAL', style: AppFonts.bodyText),
//                 ],
//               ),
//               TableRow(
//                 children: [
//                   Text('PROD01', style: AppFonts.bodyText),
//                   Text('Wireless Earbuds', style: AppFonts.bodyText),
//                   Text('2', style: AppFonts.bodyText),
//                   Text('1,499', style: AppFonts.bodyText),
//                   Text('2,998', style: AppFonts.bodyText),
//                 ],
//               ),
//               TableRow(
//                 children: [
//                   Text('SVC02', style: AppFonts.bodyText),
//                   Text('Warranty Ext.', style: AppFonts.bodyText),
//                   Text('1', style: AppFonts.bodyText),
//                   Text('299', style: AppFonts.bodyText),
//                   Text('299', style: AppFonts.bodyText),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(height: AppSpacing.medium(context)),
//           Text('SUBTOTAL:               ₹3,297', style: AppFonts.bodyText),
//           Text('DISCOUNT (10%):         -₹330', style: AppFonts.bodyText),
//           Text('TAX (18%):               ₹534', style: AppFonts.bodyText),
//           Text(
//             'GRAND TOTAL:            ₹3,501',
//             style: AppFonts.bodyText.copyWith(fontWeight: FontWeight.bold),
//           ),
//           Text(
//             'PAYMENT DETAILS:',
//             style: AppFonts.bodyText.copyWith(fontWeight: FontWeight.bold),
//           ),
//           Text(
//             '💳 Card ending 4242 (Approval: 5T8H9K)',
//             style: AppFonts.bodyText,
//           ),
//           Text('Paid: ₹3,501 • Change: ₹0', style: AppFonts.bodyText),
//           Text(
//             '[QR CODE] - Scan for payment receipt',
//             style: AppFonts.bodyText,
//           ),
//           Text('Order ID: #ORD-5T8H9K • 15-Jun-2023', style: AppFonts.bodyText),
//           Text('Thank you for your business!', style: AppFonts.bodyText),
//           Text('We appreciate your trust in us.', style: AppFonts.bodyText),
//         ],
//       ),
//     );
//   }
// }
