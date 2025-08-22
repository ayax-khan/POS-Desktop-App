import 'package:flutter/material.dart';
import 'package:pos/core/constraints/colors.dart';
import 'package:pos/core/constraints/fonts.dart';
import 'package:pos/core/constraints/spacing.dart';
import 'package:pos/core/services/hive_service.dart';
import 'location_edit_dialog.dart';

class AppBarSecondRow extends StatelessWidget {
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearch;
  final bool showFeatures;
  final bool showDate;
  final bool showBrand;
  final bool showLocation;

  const AppBarSecondRow({
    super.key,
    this.searchController,
    this.onSearch,
    this.showFeatures = true,
    this.showDate = true,
    this.showBrand = true,
    this.showLocation = true,
  });

  String _formatDate() {
    final now = DateTime.now();
    return '${now.day}/${now.month}/${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    final location = HiveService.getLocation() ?? 'Default Location';
    final hasSearch = searchController != null && onSearch != null;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (showFeatures)
              Flexible(
                flex: 2,
                child: Text(
                  'Features',
                  style: AppFonts.appBarSecondary,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            if (showDate)
              Flexible(
                flex: 2,
                child: Text(
                  _formatDate(),
                  style: AppFonts.appBarSecondary.copyWith(
                    color: AppColors.secondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            if (showBrand)
              Flexible(
                flex: 2,
                child: Text(
                  'Buy2Enjoy',
                  style: AppFonts.appBarSecondary,
                  textAlign: TextAlign.center,
                ),
              ),

            if (showLocation)
              Flexible(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        location,
                        style: AppFonts.appBarSecondary,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: AppSpacing.width(context, 0.01)),
                    IconButton(
                      icon: const Icon(Icons.edit, color: AppColors.iconColor),
                      onPressed:
                          () => showDialog(
                            context: context,
                            builder: (context) => const EditLocationDialog(),
                          ),
                    ),
                  ],
                ),
              ),

            if (hasSearch)
              Flexible(
                flex: constraints.maxWidth > 600 ? 3 : 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.width(context, 0.02),
                  ),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.iconColor,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: onSearch,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
