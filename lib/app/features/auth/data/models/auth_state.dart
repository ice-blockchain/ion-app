import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/features/auth/data/models/auth_token.dart';

part 'auth_state.freezed.dart';

sealed class AuthState {}

@freezed
class AuthenticationUnknown extends AuthState with _$AuthenticationUnknown {
  const factory AuthenticationUnknown() = _AuthenticationUnknown;
}

@freezed
class AuthenticationLoading extends AuthState with _$AuthenticationLoading {
  const factory AuthenticationLoading() = _AuthenticationLoading;
}

@freezed
class UnAuthenticated extends AuthState with _$UnAuthenticated {
  const factory UnAuthenticated() = _UnAuthenticated;
}

@freezed
class Authenticated extends AuthState with _$Authenticated {
  const factory Authenticated({
    required AuthToken authToken,
  }) = _Authenticated;
}

@freezed
class AuthenticationFailure extends AuthState with _$AuthenticationFailure {
  const factory AuthenticationFailure({
    required String message,
  }) = _AuthenticationFailure;
}
