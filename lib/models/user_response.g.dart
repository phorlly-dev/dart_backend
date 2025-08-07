// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
      sex: $enumDecodeNullable(_$SexEnumMap, json['sex']) ?? Sex.male,
      id: (json['id'] as num?)?.toInt(),
      dob: strToDt(json['dob'] as String),
      avatar: json['avatar'] as String?,
      phone: json['phone'] as String?,
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      role: json['role'] as bool? ?? false,
      status: json['status'] as bool? ?? true,
      remember: json['remember'] as bool? ?? false,
      createdAt: strToDt(json['created_at'] as String),
      updatedAt: strToDt(json['updated_at'] as String),
    );

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sex': _$SexEnumMap[instance.sex]!,
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'avatar': instance.avatar,
      'phone': instance.phone,
      'remember': instance.remember,
      'role': instance.role,
      'status': instance.status,
      'dob': dtToStr(instance.dob),
      'created_at': dtToStr(instance.createdAt),
      'updated_at': dtToStr(instance.updatedAt),
    };

const _$SexEnumMap = {
  Sex.male: 'male',
  Sex.female: 'female',
  Sex.other: 'other',
};
