// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.c.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    required List<String> authenticatedIdentityKeyNames,
    required String? currentIdentityKeyName,
    required bool suggestToAddBiometrics,
    required bool suggestToCreateLocalPasskeyCreds,
    required bool hasEventSigner,
  }) = _AuthState;

  const AuthState._();

  bool get isAuthenticated {
    return authenticatedIdentityKeyNames.isNotEmpty &&
        !suggestToAddBiometrics &&
        !suggestToCreateLocalPasskeyCreds &&
        hasEventSigner;
  }
}
