// lib/models/task.dart
import 'package:json_annotation/json_annotation.dart';
import '../data/generic_db_helper.dart';

part 'user.g.dart';

@JsonSerializable()
class User implements DbModel {
  final int? id;
  final String name;
  final String email;
  final String password;
  final bool remember;
  final bool role;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.role = false,
    this.remember = false,
  });

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    bool? role,
    bool? remember,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      remember: remember ?? this.remember,
    );
  }

  // json_serializable
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  // DbModel
  @override
  User fromMap(Map<String, dynamic> map) => User(
    id: map['id'] as int?,
    name: map['name'] as String,
    email: map['email'] as String,
    password: map['password'] as String,
    role: (map['role'] as int) == 1,
    remember: (map['remember'] as int) == 1,
  );

  @override
  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'name': name,
    'email': email,
    'password': password,
    'role': role ? 1 : 0,
    'remember': remember ? 1 : 0,
  };
}
