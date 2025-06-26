// SPDX-License-Identifier: ice License 1.0

import 'package:json_annotation/json_annotation.dart';

part 'register_init_request.j.g.dart';

@JsonSerializable()
class RegisterInitRequest {
  RegisterInitRequest({
    required this.email,
  });

  factory RegisterInitRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterInitRequestFromJson(json);

  final String email;

  Map<String, dynamic> toJson() => _$RegisterInitRequestToJson(this);

  @override
  String toString() => 'RegisterInitRequest(email: $email)';
}
