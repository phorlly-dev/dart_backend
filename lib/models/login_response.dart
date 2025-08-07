// lib/models/login_request.dart
import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final String email;
  final String password;
  final bool remember;

  LoginResponse({
    required this.email,
    required this.password,
    this.remember = false,
  });

  // json_serializable
  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
