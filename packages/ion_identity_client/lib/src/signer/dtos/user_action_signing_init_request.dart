import 'package:json_annotation/json_annotation.dart';

part 'user_action_signing_init_request.g.dart';

@JsonSerializable()
class UserActionSigningInitRequest {
  const UserActionSigningInitRequest({
    required this.userActionPayload,
    required this.userActionHttpMethod,
    required this.userActionHttpPath,
  });

  factory UserActionSigningInitRequest.fromJson(Map<String, dynamic> json) =>
      _$UserActionSigningInitRequestFromJson(json);

  final String userActionPayload;
  final String userActionHttpMethod;
  final String userActionHttpPath;

  Map<String, dynamic> toJson() => _$UserActionSigningInitRequestToJson(this);
}
