import 'package:flutter/material.dart';
import 'package:pos/core/constraints/colors.dart';
import 'package:pos/core/constraints/fonts.dart';
import 'package:pos/core/constraints/spacing.dart';

class Sidebar extends StatelessWidget {
  final Function(String) onFeatureSelected;
  final String selectedFeature;

  const Sidebar({
    super.key,
    required this.onFeatureSelected,
    required this.selectedFeature,
  });

  @override
  Widget build(BuildContext context) {
    final features = [
      'Home',
      'Products',
      'Customer',
      'Invoice',
      'Reports',
      'Settings',
    ];

    return Container(
      width: AppSpacing.width(context, 0.08), // Dynamic width
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSpacing.large(context)), // Dynamic spacing
          ...features.map(
            (feature) => GestureDetector(
              onTap: () => onFeatureSelected(feature),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.medium(context), // Dynamic spacing
                  vertical: AppSpacing.small(context), // Dynamic spacing
                ),
                color:
                    selectedFeature == feature
                        ? AppColors.primary.withOpacity(0.1)
                        : Colors.transparent,
                child: Text(
                  feature,
                  style: AppFonts.bodyText.copyWith(
                    color:
                        selectedFeature == feature
                            ? AppColors.primary
                            : AppColors.secondary,
                    fontWeight:
                        selectedFeature == feature
                            ? FontWeight.bold
                            : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
