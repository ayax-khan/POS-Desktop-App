import 'package:flutter/material.dart';
import 'package:pos/core/constraints/colors.dart';
import 'package:pos/core/constraints/fonts.dart';
import 'package:pos/core/constraints/spacing.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.all(AppSpacing.all(context, 0.03)), // Dynamic padding
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Settings', style: AppFonts.appBarTitle),
          SizedBox(height: AppSpacing.height(context, 0.02)), // Dynamic spacing
          Text('Configure app settings here.', style: AppFonts.bodyText),
        ],
      ),
    );
  }
}
