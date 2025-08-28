import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pos/features/auth/services/auth_service.dart';
import 'package:pos/features/auth/models/business_info_model.dart';

class BusinessInfoScreen extends StatefulWidget {
  const BusinessInfoScreen({super.key});

  @override
  State<BusinessInfoScreen> createState() => _BusinessInfoScreenState();
}

class _BusinessInfoScreenState extends State<BusinessInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _shopNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _countryController = TextEditingController();

  String? _logoPath;
  BusinessInfoModel? _currentBusinessInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBusinessInfo();
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _loadBusinessInfo() async {
    setState(() {
      _isLoading = true;
    });
    try {
      _currentBusinessInfo = await AuthService().getBusinessInfo();
      if (_currentBusinessInfo != null) {
        _shopNameController.text = _currentBusinessInfo!.shopName;
        _addressController.text = _currentBusinessInfo!.address;
        _phoneController.text = _currentBusinessInfo!.phoneNumber;
        _countryController.text = _currentBusinessInfo!.country;
        _logoPath = _currentBusinessInfo!.logoPath;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading business info: $e')),
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

  Future<void> _pickLogo() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _logoPath = result.files.single.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking logo: $e')));
    }
  }

  Future<void> _saveBusinessInfo() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final businessInfo = BusinessInfoModel(
        shopName: _shopNameController.text.trim(),
        logoPath: _logoPath,
        address: _addressController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        country: _countryController.text.trim(),
        lastUpdated: DateTime.now(),
      );

      await AuthService().saveBusinessInfo(businessInfo);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Business information saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save business info: $e'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Information'),
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo Section
                      Center(
                        child: GestureDetector(
                          onTap: _pickLogo,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[200],
                              border: Border.all(
                                color: Colors.grey[400]!,
                                width: 2,
                              ),
                            ),
                            child:
                                _logoPath != null
                                    ? ClipOval(
                                      child: Image.network(
                                        'file://$_logoPath',
                                        fit: BoxFit.cover,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return const Icon(
                                            Icons.business,
                                            size: 60,
                                            color: Colors.grey,
                                          );
                                        },
                                      ),
                                    )
                                    : const Icon(
                                      Icons.add_a_photo,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap to add business logo (optional)',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // Shop Name Field
                      TextFormField(
                        controller: _shopNameController,
                        decoration: InputDecoration(
                          labelText: 'Shop Name *',
                          prefixIcon: const Icon(Icons.store),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter shop name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Address Field
                      TextFormField(
                        controller: _addressController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Address *',
                          prefixIcon: const Icon(Icons.location_on),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Phone Number Field
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Phone Number *',
                          prefixIcon: const Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Country Field
                      TextFormField(
                        controller: _countryController,
                        decoration: InputDecoration(
                          labelText: 'Country *',
                          prefixIcon: const Icon(Icons.flag),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter country';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),

                      // Save Button
                      ElevatedButton(
                        onPressed: _isLoading ? null : _saveBusinessInfo,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
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
                                  'Save Business Information',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
