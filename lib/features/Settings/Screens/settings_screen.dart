import 'package:flutter/material.dart';
import 'package:pos/features/Settings/Screens/profile_screen.dart';
import 'package:pos/features/Settings/Screens/business_info_screen.dart';
import 'package:pos/features/Settings/Screens/activation_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.person, color: Colors.blueAccent),
                title: const Text(
                  'User Profile',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                subtitle: const Text('Manage your personal information'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: SizedBox(
                          height: 900,
                          width: 550,
                          child: ProfileScreen(),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Business Info Section (Placeholder)
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.business, color: Colors.green),
                title: const Text(
                  'Business Information',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                subtitle: const Text('Manage your shop details and logo'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: SizedBox(
                          height: 900,
                          width: 550,
                          child: BusinessInfoScreen(),
                        ),
                      );
                    },
                  );
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const BusinessInfoScreen()),
                  // );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Activation Section (Placeholder)
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.vpn_key, color: Colors.orange),
                title: const Text(
                  'License Activation',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                subtitle: const Text('Activate or extend your app license'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: SizedBox(
                          height: 900,
                          width: 550,
                          child: ActivationScreen(),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
