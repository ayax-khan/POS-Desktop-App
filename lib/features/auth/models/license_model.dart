import 'package:hive/hive.dart';

part 'license_model.g.dart';

@HiveType(typeId: 5)
class LicenseModel {
  @HiveField(0)
  final String licenseCode;

  @HiveField(1)
  final DateTime activationDate;

  @HiveField(2)
  final int durationInDays;

  @HiveField(3)
  final bool isActive;

  @HiveField(4)
  final DateTime? lastLoginTime;

  LicenseModel({
    required this.licenseCode,
    required this.activationDate,
    required this.durationInDays,
    required this.isActive,
    this.lastLoginTime,
  });

  DateTime get expiryDate => activationDate.add(Duration(days: durationInDays));
  
  int get remainingDays {
    final now = DateTime.now();
    final remaining = expiryDate.difference(now).inDays;
    return remaining > 0 ? remaining : 0;
  }

  bool get isExpired => DateTime.now().isAfter(expiryDate);
}

