import 'package:hive/hive.dart';
import 'package:pos/features/auth/models/user_model.dart';
import 'package:pos/features/auth/models/license_model.dart';

class AuthService {
  static const String _userBoxName = 'user_box';
  static const String _licenseBoxName = 'license_box';
  static const String _userKey = 'current_user';
  static const String _licenseKey = 'current_license';

  // Predefined license codes with their durations (in days)
  static const Map<String, int> _validLicenseCodes = {
    'p56 o98 s87 p12 o54 s65': 30, // 1 month
    'a12 b34 c56 d78 e90 f12': 90, // 3 months
    'x11 y22 z33 a44 b55 c66': 365, // 1 year
    'test123 demo456 trial789 free000 basic111 premium222': 7, // 7 days trial
  };

  // Validate individual code segment format
  bool _isValidCodeSegment(String segment) {
    if (segment.length != 3) return false;

    // Check if it contains only alphanumeric characters
    final alphanumericRegex = RegExp(r'^[a-zA-Z0-9]{3}$');
    return alphanumericRegex.hasMatch(segment);
  }

  // Validate complete license code format
  bool _isValidLicenseFormat(String code) {
    final segments = code.split(' ');

    // Must have exactly 6 segments
    if (segments.length != 6) return false;

    // Each segment must be valid
    for (String segment in segments) {
      if (!_isValidCodeSegment(segment)) return false;
    }

    return true;
  }

  Future<Box<UserModel>> _getUserBox() async {
    return await Hive.openBox<UserModel>(_userBoxName);
  }

  Future<Box<LicenseModel>> _getLicenseBox() async {
    return await Hive.openBox<LicenseModel>(_licenseBoxName);
  }

  Future<bool> isUserRegistered() async {
    try {
      final box = await _getUserBox();
      final user = box.get(_userKey);
      return user != null && user.isRegistered;
    } catch (e) {
      return false;
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final box = await _getUserBox();
      return box.get(_userKey);
    } catch (e) {
      return null;
    }
  }

  Future<void> registerUser({
    required String name,
    required String shopAddress,
    required String phoneNumber,
    String? profilePicturePath,
  }) async {
    try {
      final box = await _getUserBox();
      final user = UserModel(
        name: name,
        shopAddress: shopAddress,
        phoneNumber: phoneNumber,
        profilePicturePath: profilePicturePath,
        registrationDate: DateTime.now(),
        isRegistered: true,
      );
      await box.put(_userKey, user);
    } catch (e) {
      throw Exception('Failed to register user: $e');
    }
  }

  Future<bool> validateLicenseCode(String code) async {
    try {
      final normalizedCode =
          code.trim().toLowerCase(); // Convert to lowercase for comparison
      print('Normalized code: $normalizedCode');
      print('Valid license codes: ${_validLicenseCodes.keys.toList()}');

      // Check if the format is valid
      if (!_isValidLicenseFormat(normalizedCode)) {
        print('Invalid license format');
        return false;
      }

      // Check if the code exists in our valid codes
      if (!_validLicenseCodes.containsKey(normalizedCode)) {
        print('Code not found in valid licenses');
        return false;
      }

      final durationInDays = _validLicenseCodes[normalizedCode]!;
      final box = await _getLicenseBox();

      // Check if this code is already used and still active
      final existingLicense = box.get(_licenseKey);
      if (existingLicense != null &&
          existingLicense.licenseCode.toLowerCase() == normalizedCode &&
          existingLicense.isActive &&
          !existingLicense.isExpired) {
        // Code already active, just update last login time
        final updatedLicense = LicenseModel(
          licenseCode: existingLicense.licenseCode,
          activationDate: existingLicense.activationDate,
          durationInDays: existingLicense.durationInDays,
          isActive: true,
          lastLoginTime: DateTime.now(),
        );
        await box.put(_licenseKey, updatedLicense);
        print('Updated existing license with new login time');
        return true;
      }

      // Create new license activation
      final license = LicenseModel(
        licenseCode: normalizedCode,
        activationDate: DateTime.now(),
        durationInDays: durationInDays,
        isActive: true,
        lastLoginTime: DateTime.now(),
      );

      await box.put(_licenseKey, license);
      print('Created new license');
      return true;
    } catch (e) {
      print('Error validating license: $e');
      throw Exception('Failed to validate license: $e');
    }
  }

  Future<bool> hasValidLicense() async {
    try {
      final box = await _getLicenseBox();
      final license = box.get(_licenseKey);

      if (license == null || !license.isActive) {
        return false;
      }

      // Check if license is expired
      if (license.isExpired) {
        // Deactivate expired license
        final updatedLicense = LicenseModel(
          licenseCode: license.licenseCode,
          activationDate: license.activationDate,
          durationInDays: license.durationInDays,
          isActive: false,
          lastLoginTime: license.lastLoginTime,
        );
        await box.put(_licenseKey, updatedLicense);
        return false;
      }

      // Update last login time
      final updatedLicense = LicenseModel(
        licenseCode: license.licenseCode,
        activationDate: license.activationDate,
        durationInDays: license.durationInDays,
        isActive: license.isActive,
        lastLoginTime: DateTime.now(),
      );
      await box.put(_licenseKey, updatedLicense);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<LicenseModel?> getCurrentLicense() async {
    try {
      final box = await _getLicenseBox();
      return box.get(_licenseKey);
    } catch (e) {
      return null;
    }
  }

  Future<int> getRemainingDays() async {
    try {
      final license = await getCurrentLicense();
      if (license == null || !license.isActive) {
        return 0;
      }
      return license.remainingDays;
    } catch (e) {
      return 0;
    }
  }

  Future<void> logout() async {
    try {
      final box = await _getLicenseBox();
      final license = box.get(_licenseKey);

      if (license != null) {
        final updatedLicense = LicenseModel(
          licenseCode: license.licenseCode,
          activationDate: license.activationDate,
          durationInDays: license.durationInDays,
          isActive: false,
          lastLoginTime: license.lastLoginTime,
        );
        await box.put(_licenseKey, updatedLicense);
      }
    } catch (e) {
      // Handle error silently
    }
  }

  // Method to check license status periodically
  Future<bool> checkLicenseStatus() async {
    return await hasValidLicense();
  }

  // Debug method to inspect current license
  Future<void> debugLicense() async {
    final box = await _getLicenseBox();
    final license = box.get(_licenseKey);
    print(
      'Current license: $license, isExpired: ${license?.isExpired}, isActive: ${license?.isActive}',
    );
  }
}
