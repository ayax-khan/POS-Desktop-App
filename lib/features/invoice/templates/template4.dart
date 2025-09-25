// import 'package:flutter/material.dart';
// import 'package:pos/core/constraints/fonts.dart';
// import 'package:pos/core/constraints/spacing.dart';

// class Template4 extends StatelessWidget {
//   const Template4({super.key});

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
//                 Text(
//                   'FAST TRADERS',
//                   style: AppFonts.bodyText.copyWith(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   'Wholesale • Retail • Distribution',
//                   style: AppFonts.bodyText,
//                 ),
//                 Text(
//                   'GSTIN: 33CCCCC0000C3Z7 • DL-1-2023',
//                   style: AppFonts.bodyText,
//                 ),
//               ],
//             ),
//           ),
//           Text('INV: WH-105 • 15-Jun-2023 14:30', style: AppFonts.bodyText),
//           Text('CUST: #C-5582 • John Doe', style: AppFonts.bodyText),
//           SizedBox(height: AppSpacing.medium(context)),
//           Table(
//             border: TableBorder.all(),
//             columnWidths: const {
//               0: FlexColumnWidth(1),
//               1: FlexColumnWidth(1),
//               2: FlexColumnWidth(1),
//               3: FlexColumnWidth(1),
//               4: FlexColumnWidth(1),
//             },
//             children: [
//               TableRow(
//                 children: [
//                   Text('ITEM', style: AppFonts.bodyText),
//                   Text('HSN', style: AppFonts.bodyText),
//                   Text('QTY', style: AppFonts.bodyText),
//                   Text('PRICE', style: AppFonts.bodyText),
//                   Text('TOTAL', style: AppFonts.bodyText),
//                 ],
//               ),
//               TableRow(
//                 children: [
//                   Text('Sugar', style: AppFonts.bodyText),
//                   Text('1701 99 10', style: AppFonts.bodyText),
//                   Text('5Kg', style: AppFonts.bodyText),
//                   Text('45/kg', style: AppFonts.bodyText),
//                   Text('225.00', style: AppFonts.bodyText),
//                 ],
//               ),
//               TableRow(
//                 children: [
//                   Text('Tea', style: AppFonts.bodyText),
//                   Text('0902 30 00', style: AppFonts.bodyText),
//                   Text('2Pkt', style: AppFonts.bodyText),
//                   Text('110', style: AppFonts.bodyText),
//                   Text('220.00', style: AppFonts.bodyText),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(height: AppSpacing.medium(context)),
//           Text(
//             'SUBTOTAL:                       445.00',
//             style: AppFonts.bodyText,
//           ),
//           Text(
//             'CGST 2.5%:                       11.13',
//             style: AppFonts.bodyText,
//           ),
//           Text(
//             'SGST 2.5%:                       11.13',
//             style: AppFonts.bodyText,
//           ),
//           Text(
//             'ROUND OFF:                        0.74',
//             style: AppFonts.bodyText,
//           ),
//           Text(
//             'TOTAL:                         468.00',
//             style: AppFonts.bodyText.copyWith(fontWeight: FontWeight.bold),
//           ),
//           Text('Paid: 500.00 • Change: 32.00', style: AppFonts.bodyText),
//           Text(
//             'Mode: Cash • Staff: Rajesh (ID: E-05)',
//             style: AppFonts.bodyText,
//           ),
//           Text('THANK YOU • VISIT AGAIN!', style: AppFonts.bodyText),
//           Text(
//             '[Small QR Code for GST verification]',
//             style: AppFonts.bodyText,
//           ),
//         ],
//       ),
//     );
//   }
// }
