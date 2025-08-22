import 'package:flutter/material.dart';
import 'package:pos/core/constraints/colors.dart';
import 'package:pos/core/constraints/fonts.dart';
import 'package:pos/features/auth/widgets/license_timer_widget.dart';
import 'package:pos/features/auth/widgets/logout_button.dart';

class AppBarFirstRow extends StatelessWidget {
  const AppBarFirstRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.menu, color: AppColors.iconColor),
          onPressed: () {
            // TODO: Implement three-dot menu functionality
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Menu clicked')));
          },
        ),
        Text('AURA POS', style: AppFonts.appBarTitle),
        Row(
          children: [
            const LicenseTimerWidget(), // License timer widget
            IconButton(
              icon: const Icon(Icons.notifications, color: AppColors.iconColor),
              onPressed: () {
                // TODO: Implement notifications functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notifications clicked')),
                );
              },
            ),
            const LogoutButton(), // Logout button
          ],
        ),
      ],
    );
  }
}
