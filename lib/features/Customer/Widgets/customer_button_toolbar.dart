import 'package:flutter/material.dart';
import 'package:pos/core/constraints/colors.dart';
import '../../../core/constraints/spacing.dart';

class CustomerButtonToolbar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onDelete;
  final VoidCallback? onExport;
  final VoidCallback? onAssignGroup;
  final VoidCallback? onSendCampaign;

  const CustomerButtonToolbar({
    super.key,
    required this.selectedCount,
    required this.onDelete,
    this.onExport,
    this.onAssignGroup,
    this.onSendCampaign,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.medium(context),
        vertical: AppSpacing.small(context),
      ),
      child: Row(
        children: [
          Text(
            '$selectedCount selected',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 24),
          _buildToolbarButton(
            label: 'Delete',

            icon: Icons.delete_outline,
            onPressed: onDelete,
          ),
          if (onExport != null)
            _buildToolbarButton(
              label: 'Export',
              icon: Icons.download_outlined,
              onPressed: onExport!,
            ),
          if (onAssignGroup != null)
            _buildToolbarButton(
              label: 'Assign to Group',
              icon: Icons.group_add_outlined,
              onPressed: onAssignGroup!,
            ),
          if (onSendCampaign != null)
            _buildToolbarButton(
              label: 'Send Campaign',
              icon: Icons.email_outlined,
              onPressed: onSendCampaign!,
            ),
        ],
      ),
    );
  }

  Widget _buildToolbarButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: TextButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      ),
    );
  }
}
