import 'package:hive/hive.dart';
part 'customer_model.g.dart';

@HiveType(typeId: 1)
class Customer extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String phone;

  @HiveField(4)
  final String group;

  @HiveField(5)
  final String? notes;

  @HiveField(6)
  final String? lastVisited;

  @HiveField(7)
  final DateTime createdAt;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.group,
    this.notes,
    this.lastVisited,
    required this.createdAt,
  });

  Customer copyWith({
    String? name,
    String? email,
    String? phone,
    String? group,
    String? notes,
    String? lastVisited,
  }) {
    return Customer(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      group: group ?? this.group,
      notes: notes ?? this.notes,
      lastVisited: lastVisited ?? this.lastVisited,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'group': group,
      'notes': notes,
      'lastVisited': lastVisited,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      group: json['group'],
      notes: json['notes'],
      lastVisited: json['lastVisited'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
