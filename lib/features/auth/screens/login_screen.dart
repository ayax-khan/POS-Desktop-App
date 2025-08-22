import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos/features/auth/services/auth_service.dart';
import 'package:pos/features/auth/utils/upper_case_formatter.dart';
import 'package:pos/features/navigation/screens/navigation_screen.dart';
import 'dart:async';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  Timer? _loginTimer;

  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Debug current license state on screen load
    AuthService().debugLicense();
  }

  @override
  void dispose() {
    _loginTimer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  bool _isValidCodeSegment(String segment) {
    if (segment.length != 3) return false;
    final alphanumericRegex = RegExp(r'^[a-zA-Z0-9]{3}$');
    return alphanumericRegex.hasMatch(segment);
  }

  void _onCodeChanged(String value, int index) {
    final upperValue = value.toUpperCase();
    if (upperValue != value) {
      _controllers[index].text = upperValue;
      _controllers[index].selection = TextSelection.fromPosition(
        TextPosition(offset: upperValue.length),
      );
    }

    if (upperValue.length == 3) {
      if (!_isValidCodeSegment(upperValue)) {
        setState(() {
          _errorMessage =
              'Field ${index + 1} contains invalid characters. Use only letters and numbers.';
        });
        return;
      }
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _loginTimer?.cancel();
        _loginTimer = Timer(const Duration(milliseconds: 500), _login);
      }
    } else if (upperValue.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    setState(() {
      _errorMessage = '';
    });
  }

  String _getEnteredCode() {
    return _controllers
        .map((controller) => controller.text.toUpperCase())
        .join(' ');
  }

  bool _isCodeComplete() {
    return _controllers.every((controller) => controller.text.length == 3);
  }

  bool _isValidCodeFormat() {
    for (var controller in _controllers) {
      if (!_isValidCodeSegment(controller.text)) return false;
    }
    return true;
  }

  Future<void> _login() async {
    print('Attempting login with code: ${_getEnteredCode()}');

    if (!_isCodeComplete()) {
      setState(() {
        _errorMessage = 'Please fill all code fields';
      });
      print('Login failed: Incomplete code');
      return;
    }

    if (!_isValidCodeFormat()) {
      setState(() {
        _errorMessage = 'Invalid code format. Use only letters and numbers.';
      });
      print('Login failed: Invalid code format');
      return;
    }

    final code = _getEnteredCode();

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final authService = AuthService();
      await authService
          .debugLicense(); // Debug stored license before validation
      final success = await authService.validateLicenseCode(code);
      print('License validation result: $success');

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful!'),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const NavigationScreen()),
          );
        }
      } else {
        setState(() {
          _errorMessage = 'Invalid license code. Please check and try again.';
        });
        print('Login failed: Invalid license code');
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            'Login failed: ${e.toString().replaceAll('Exception: ', '')}';
      });
      print('Login error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _clearCode() {
    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
    setState(() {
      _errorMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/aura_logo.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.lock,
                                size: 50,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Enter License Code',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please enter your 6-part license code',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (index) {
                        return SizedBox(
                          width: 70,
                          child: TextFormField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                            maxLength: 3,
                            textCapitalization: TextCapitalization.characters,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9]'),
                              ),
                              UpperCaseTextFormatter(),
                            ],
                            decoration: InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color:
                                      _isValidCodeSegment(
                                                _controllers[index].text,
                                              ) ||
                                              _controllers[index].text.isEmpty
                                          ? Colors.grey[400]!
                                          : Colors.red,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor:
                                  _controllers[index].text.length == 3
                                      ? _isValidCodeSegment(
                                            _controllers[index].text,
                                          )
                                          ? Colors.green[50]
                                          : Colors.red[50]
                                      : Colors.grey[50],
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                            ),
                            onChanged: (value) => _onCodeChanged(value, index),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Valid Test Codes:',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'P56 O98 S87 P12 O54 S65 (30 days)',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.blue[600],
                              fontFamily: 'monospace',
                            ),
                          ),
                          Text(
                            'A12 B34 C56 D78 E90 F12 (90 days)',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.blue[600],
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_errorMessage.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red[200]!),
                        ),
                        child: Text(
                          _errorMessage,
                          style: TextStyle(
                            color: Colors.red[700],
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child:
                          _isLoading
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
                                'Login',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _clearCode,
                      child: Text(
                        'Clear Code',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
