import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pos/core/services/hive_service.dart';
import 'package:pos/features/Home/Services/dashboard_service.dart';
import 'package:pos/features/navigation/screens/navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await HiveService.init();
  await DashboardService().initialize(); // ✅ ab pehle hi init ho jayega
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POS App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const NavigationScreen(),
    );
  }
}
