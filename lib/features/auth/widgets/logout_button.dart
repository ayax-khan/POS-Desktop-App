import 'package:flutter/material.dart';
import 'package:pos/features/auth/services/auth_service.dart';
import 'package:pos/features/auth/screens/login_screen.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  Future<void> _showLogoutDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      await _logout(context);
    }
  }

  Future<void> _logout(BuildContext context) async {
    try {
      final authService = AuthService();
      await authService.logout();

      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.logout,
        color: Colors.red,
      ),
      tooltip: 'Logout',
      onPressed: () => _showLogoutDialog(context),
    );
  }
}

