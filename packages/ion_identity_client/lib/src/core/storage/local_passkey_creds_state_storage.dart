// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion_identity_client/src/core/storage/data_storage.dart';
import 'package:ion_identity_client/src/core/types/local_passkey_creds_state.dart';

class LocalPasskeyCredsStateStorage extends DataStorage<LocalPasskeyCredsState> {
  LocalPasskeyCredsStateStorage({
    required super.secureStorage,
  }) : super(
          storageKey: 'ion_identity_client_new_passkey_creds_state_key',
          fromJson: (json) {
            final value = json['value'] as String;
            return LocalPasskeyCredsState.values.firstWhere((e) => e.name == value);
          },
          toJson: (value) => {'value': value.name},
        );

  LocalPasskeyCredsState? getLocalPasskeyCredsState({required String username}) =>
      super.getData(key: username);

  Future<void> updateLocalPasskeyCredsState({
    required String username,
    required LocalPasskeyCredsState state,
  }) =>
      super.setData(key: username, value: state);

  Future<void> removeLocalPasskeyCredsState({required String username}) =>
      super.removeData(key: username);

  Future<void> clearAllPrivateKeys() => super.clearAllData();
}
