import 'package:flutter/material.dart';
import 'package:pos/core/constraints/colors.dart';
import 'package:pos/core/constraints/fonts.dart';
import 'package:pos/features/auth/services/auth_service.dart';
import 'package:pos/features/auth/widgets/license_timer_widget.dart';
import 'package:pos/features/auth/widgets/logout_button.dart';
import 'package:pos/features/auth/models/business_info_model.dart';
import 'dart:io';

class AppBarFirstRow extends StatefulWidget {
  const AppBarFirstRow({super.key});

  @override
  State<AppBarFirstRow> createState() => _AppBarFirstRowState();
}

class _AppBarFirstRowState extends State<AppBarFirstRow> {
  BusinessInfoModel? _businessInfo;

  @override
  void initState() {
    super.initState();
    _loadBusinessInfo();
  }

  Future<void> _loadBusinessInfo() async {
    try {
      final businessInfo = await AuthService().getBusinessInfo();
      if (mounted) {
        setState(() {
          _businessInfo = businessInfo;
        });
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Widget _buildLogoOrMenuIcon() {
    if (_businessInfo?.logoPath != null &&
        _businessInfo!.logoPath!.isNotEmpty) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.file(
            File(_businessInfo!.logoPath!),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.menu, color: AppColors.iconColor);
            },
          ),
        ),
      );
    } else {
      return const Icon(Icons.menu, color: AppColors.iconColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: _buildLogoOrMenuIcon(),
          onPressed: () {
            // TODO: Implement menu functionality
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
