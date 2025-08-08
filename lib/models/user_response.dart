// lib/models/task.dart
// import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dart_backend/utils/index.dart';
import 'package:json_annotation/json_annotation.dart';
import '../services/db_request.dart';

part 'user_response.g.dart';
part 'extension_user.dart';

@JsonSerializable()
// @CopyWith()
class UserResponse implements IModel {
  // @CopyWithField(immutable: true)
  final int? id;

  @JsonKey(name: 'sex')
  final Sex sex;

  final String name, email, password;
  final String? avatar, phone;

  final bool remember;
  final bool role;
  final bool status;

  @JsonKey(name: 'dob', fromJson: strToDt, toJson: dtToStr)
  final DateTime dob;

  @JsonKey(name: 'created_at', fromJson: strToDt, toJson: dtToStr)
  final DateTime createdAt;

  @JsonKey(name: 'updated_at', fromJson: strToDt, toJson: dtToStr)
  final DateTime updatedAt;

  UserResponse({
    this.sex = Sex.male,
    this.id,
    DateTime? dob,
    this.avatar,
    this.phone,
    required this.name,
    required this.email,
    required this.password,
    this.role = false,
    this.status = true,
    this.remember = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : dob = dob ?? dtNow(),
        createdAt = createdAt ?? dtNow(),
        updatedAt = updatedAt ?? dtNow();

  UserResponse copyWith({
    int? id,
    String? name,
    DateTime? dob,
    String? avatar,
    String? phone,
    String? email,
    String? password,
    Sex? sex,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? remember,
    bool? role,
    bool? status,
  }) {
    return UserResponse(
      id: id ?? this.id,
      name: name ?? this.name,
      sex: sex ?? this.sex,
      dob: dob ?? this.dob,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      role: role ?? this.role,
      status: status ?? this.status,
      remember: remember ?? this.remember,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // json_serializable
  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UserResponseToJson(this);

  factory UserResponse.formData(Map<String, dynamic> form) => UserResponse(
        id: form['id'] as int?,
        name: form['name'] as String,
        email: form['email'] as String,
        dob: form['dob'] != null ? strToDt(form['dob'] as String) : null,
        sex: SexX.fromCode(form['sex'] as int),
        avatar: form['avatar'] as String?,
        phone: form['phone'] as String?,
        password: form['password'] as String,
        role: (form['role'] as int) == 1,
        status: (form['status'] as int) == 1,
        remember:
            ((form['remember'] as int?) ?? 0) == 1, // cast as int? then default
        createdAt: parseOrNow(form['created_at'] as String?),
        updatedAt: parseOrNow(form['updated_at'] as String?),
      );

  // DbModel
  @override
  UserResponse fromMap(Map<String, dynamic> map) => UserResponse(
        id: map['id'] as int?,
        name: map['name'] as String,
        email: map['email'] as String,
        dob: map['dob'] != null ? strToDt(map['dob'] as String) : null,
        sex: SexX.fromCode(map['sex'] as int),
        avatar: map['avatar'] as String?,
        phone: map['phone'] as String?,
        password: map['password'] as String,
        role: (map['role'] as int) == 1,
        status: (map['status'] as int) == 1,
        remember:
            ((map['remember'] as int?) ?? 0) == 1, // cast as int? then default
        createdAt: parseOrNow(map['created_at'] as String?),
        updatedAt: parseOrNow(map['updated_at'] as String?),
      );

  @override
  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'name': name,
        'email': email,
        'dob': dob.toIso8601String(),
        'sex': sex.code,
        'avatar': avatar,
        'phone': phone,
        'password': password,
        'role': role ? 1 : 0,
        'status': status ? 1 : 0,
        'remember': remember ? 1 : 0,
      };
}
