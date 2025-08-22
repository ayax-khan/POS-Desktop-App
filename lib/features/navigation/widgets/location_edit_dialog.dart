import 'package:flutter/material.dart';
import 'package:pos/core/constraints/colors.dart';
import 'package:pos/core/constraints/fonts.dart';
import 'package:pos/core/services/hive_service.dart';

class EditLocationDialog extends StatefulWidget {
  const EditLocationDialog({super.key});

  @override
  State<EditLocationDialog> createState() => _EditLocationDialogState();
}

class _EditLocationDialogState extends State<EditLocationDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = HiveService.getLocation() ?? 'Default Location';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Location'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Location',
        ),
        style: AppFonts.bodyText,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.secondary),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            await HiveService.saveLocation(_controller.text);
            Navigator.of(context).pop();
            setState(() {}); // Refresh UI
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: const Text('Save', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
