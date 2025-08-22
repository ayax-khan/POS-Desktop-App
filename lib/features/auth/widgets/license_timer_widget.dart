import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pos/features/auth/services/auth_service.dart';
import 'package:pos/features/auth/screens/login_screen.dart';

class LicenseTimerWidget extends StatefulWidget {
  const LicenseTimerWidget({super.key});

  @override
  State<LicenseTimerWidget> createState() => _LicenseTimerWidgetState();
}

class _LicenseTimerWidgetState extends State<LicenseTimerWidget> {
  Timer? _timer;
  int _remainingDays = 0;
  bool _isExpired = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeTimer();
    _startPeriodicCheck();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _initializeTimer() async {
    await _updateLicenseStatus();
  }

  void _startPeriodicCheck() {
    // Check license status every minute
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _updateLicenseStatus();
    });
  }

  Future<void> _updateLicenseStatus() async {
    try {
      final authService = AuthService();
      final hasValidLicense = await authService.checkLicenseStatus();

      if (!hasValidLicense) {
        setState(() {
          _isExpired = true;
          _remainingDays = 0;
          _isLoading = false;
        });
        _handleLicenseExpired();
        return;
      }

      final remainingDays = await authService.getRemainingDays();

      if (mounted) {
        setState(() {
          _remainingDays = remainingDays;
          _isExpired = remainingDays <= 0;
          _isLoading = false;
        });

        if (_isExpired) {
          _handleLicenseExpired();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isExpired = true;
          _remainingDays = 0;
          _isLoading = false;
        });
      }
    }
  }

  void _handleLicenseExpired() {
    // Show dialog and navigate to login screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('License Expired'),
              content: const Text(
                'Your license has expired. Please enter a new license code to continue using the application.',
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Text('Login Again'),
                ),
              ],
            );
          },
        );
      }
    });
  }

  Color _getTimerColor() {
    if (_isExpired || _remainingDays <= 0) {
      return Colors.red;
    } else if (_remainingDays <= 7) {
      return Colors.orange;
    } else if (_remainingDays <= 15) {
      return Colors.yellow[700] ?? Colors.yellow; // ✅ Safe
    } else {
      return Colors.green;
    }
  }

  IconData _getTimerIcon() {
    if (_isExpired || _remainingDays <= 0) {
      return Icons.error;
    } else if (_remainingDays <= 7) {
      return Icons.warning;
    } else {
      return Icons.schedule;
    }
  }

  String _getTimerText() {
    if (_isLoading) {
      return 'Loading...';
    }

    if (_isExpired || _remainingDays <= 0) {
      return 'Expired';
    }

    if (_remainingDays == 1) {
      return '1 day left';
    }

    return '$_remainingDays days left';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: _getTimerColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _getTimerColor(), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getTimerIcon(), color: _getTimerColor(), size: 16),
          const SizedBox(width: 6),
          Text(
            _getTimerText(),
            style: TextStyle(
              color: _getTimerColor(),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
