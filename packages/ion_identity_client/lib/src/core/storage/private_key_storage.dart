// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion_identity_client/src/auth/dtos/private_key_data.j.dart';
import 'package:ion_identity_client/src/core/storage/data_storage.dart';

class PrivateKeyStorage extends DataStorage<PrivateKeyData> {
  PrivateKeyStorage({
    required super.secureStorage,
  }) : super(
          storageKey: 'ion_identity_client_private_keys_key',
          // Use the generated fromJson
          fromJson: PrivateKeyData.fromJson,
          // Use the generated toJson
          toJson: (data) => data.toJson(),
        );

  PrivateKeyData? getPrivateKey({required String username}) => super.getData(key: username);

  Future<void> setPrivateKey({required String username, required PrivateKeyData privateKeyData}) =>
      super.setData(key: username, value: privateKeyData);

  Future<void> removePrivateKey({required String username}) => super.removeData(key: username);

  Future<void> clearAllPrivateKeys() => super.clearAllData();
}
