import 'package:flutter/material.dart';
import 'package:pos/core/constraints/fonts.dart';
import 'package:pos/core/constraints/spacing.dart';

class InvoiceButtons extends StatelessWidget {
  final VoidCallback onCreateOrderTapped;
  final VoidCallback onTransactionsTapped;

  const InvoiceButtons({
    super.key,
    required this.onCreateOrderTapped,
    required this.onTransactionsTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildButton(
          context,
          label: 'Create Order',
          onPressed: onCreateOrderTapped,
          color: Colors.green,
          icon: Icons.add_circle_outline,
          tooltip: 'Create a new order',
        ),
        SizedBox(width: AppSpacing.medium(context)),
        _buildButton(
          context,
          label: 'Transactions',
          onPressed: onTransactionsTapped,
          color: Colors.blue,
          icon: Icons.history,
          tooltip: 'View transaction history',
        ),
      ],
    );
  }
}

Widget _buildButton(
  BuildContext context, {
  required String label,
  required IconData icon,
  required String tooltip,
  Color color = Colors.blue,
  VoidCallback? onPressed,
}) {
  return Tooltip(
    message: tooltip,
    child: ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: MediaQuery.of(context).size.width * 0.015,
        color: Colors.white,
      ),
      label: Text(
        label,
        style: AppFonts.bodyText.copyWith(
          color: Colors.white,
          fontSize: MediaQuery.of(context).size.width * 0.01,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.medium(context),
          vertical: AppSpacing.small(context),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
      ),
    ),
  );
}
