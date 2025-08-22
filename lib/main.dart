import 'package:flutter/material.dart';
import 'package:pos/features/Home/Services/dashboard_service.dart';
import 'package:pos/features/auth/screens/welcome_screen.dart';
import 'package:pos/features/navigation/screens/navigation_screen.dart';
import 'package:pos/core/services/hive_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await HiveService.init(); // Initialize Hive & all boxes
    await DashboardService().initialize(); // Initialize DashboardService
    runApp(const MyApp());
  } catch (e) {
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "⚠️ Error initializing app data.\n\n$e",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AURA POS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/', // 👈 Default route
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/main': (context) => const NavigationScreen(),
      },
    );
  }
}
