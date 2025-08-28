import 'package:hive/hive.dart';

part 'business_info_model.g.dart';

@HiveType(typeId: 14)
class BusinessInfoModel {
  @HiveField(0)
  final String shopName;

  @HiveField(1)
  final String? logoPath;

  @HiveField(2)
  final String address;

  @HiveField(3)
  final String phoneNumber;

  @HiveField(4)
  final String country;

  @HiveField(5)
  final DateTime lastUpdated;

  BusinessInfoModel({
    required this.shopName,
    this.logoPath,
    required this.address,
    required this.phoneNumber,
    required this.country,
    required this.lastUpdated,
  });

  BusinessInfoModel copyWith({
    String? shopName,
    String? logoPath,
    String? address,
    String? phoneNumber,
    String? country,
    DateTime? lastUpdated,
  }) {
    return BusinessInfoModel(
      shopName: shopName ?? this.shopName,
      logoPath: logoPath ?? this.logoPath,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      country: country ?? this.country,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
