import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 4)
class UserModel {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String shopAddress;

  @HiveField(3)
  final String phoneNumber;

  @HiveField(4)
  final String? profilePicturePath;

  @HiveField(5)
  final DateTime registrationDate;

  @HiveField(6)
  final bool isRegistered;

  UserModel({
    required this.name,
    required this.email,
    required this.shopAddress,
    required this.phoneNumber,
    this.profilePicturePath,
    required this.registrationDate,
    required this.isRegistered,
  });
}

