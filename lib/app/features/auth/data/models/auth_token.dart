import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_token.freezed.dart';

@freezed
class AuthToken with _$AuthToken {
  const factory AuthToken({
    required String access,
    required String refresh,
  }) = _AuthToken;
}
