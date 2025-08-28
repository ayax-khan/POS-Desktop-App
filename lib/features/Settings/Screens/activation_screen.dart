import 'package:flutter/material.dart';
import 'package:pos/features/auth/services/auth_service.dart';
import 'package:pos/features/auth/models/license_model.dart';

class ActivationScreen extends StatefulWidget {
  const ActivationScreen({super.key});

  @override
  State<ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  final _licenseController = TextEditingController();
  LicenseModel? _currentLicense;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentLicense();
  }

  @override
  void dispose() {
    _licenseController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentLicense() async {
    setState(() {
      _isLoading = true;
    });
    try {
      _currentLicense = await AuthService().getCurrentLicense();
    } catch (e) {
      // Handle error silently
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _activateLicense() async {
    if (_licenseController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a license code'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final isValid = await AuthService().validateLicenseCode(_licenseController.text.trim());
      
      if (isValid) {
        await _loadCurrentLicense(); // Reload license info
        _licenseController.clear();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('License activated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid license code. Please check and try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error activating license: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildLicenseStatus() {
    if (_currentLicense == null) {
      return Card(
        color: Colors.red.shade50,
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(Icons.warning, color: Colors.red, size: 48),
              SizedBox(height: 8),
              Text(
                'No Active License',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              Text(
                'Please activate a license to use the application',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      );
    }

    final isExpired = _currentLicense!.isExpired;
    final remainingDays = _currentLicense!.remainingDays;

    return Card(
      color: isExpired ? Colors.red.shade50 : Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              isExpired ? Icons.error : Icons.check_circle,
              color: isExpired ? Colors.red : Colors.green,
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              isExpired ? 'License Expired' : 'License Active',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isExpired ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Duration: ${_currentLicense!.durationInDays} days',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Activated: ${_currentLicense!.activationDate.toLocal().toString().split(' ')[0]}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              isExpired 
                ? 'Expired ${(-remainingDays).abs()} days ago'
                : 'Remaining: $remainingDays days',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isExpired ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('License Activation'),
        backgroundColor: Colors.orange[600],
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildLicenseStatus(),
                  const SizedBox(height: 24),
                  
                  // License Code Input
                  TextField(
                    controller: _licenseController,
                    decoration: InputDecoration(
                      labelText: 'License Code',
                      hintText: 'Enter your license code (e.g., abc def ghi jkl mno pqr)',
                      prefixIcon: const Icon(Icons.vpn_key),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  
                  // Activate Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _activateLicense,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Activate License',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(height: 24),
                  
                  // License Information
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Available License Durations:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text('• 30 days license'),
                          const Text('• 60 days license'),
                          const Text('• 90 days license'),
                          const Text('• 365 days license'),
                          const SizedBox(height: 16),
                          const Text(
                            'Note:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'License codes are case-insensitive and should be entered exactly as provided. Each license can only be activated once.',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

