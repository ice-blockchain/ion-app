// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion_identity_client/src/core/storage/data_storage.dart';

class PrivateKeyStorage extends DataStorage<String> {
  PrivateKeyStorage({
    required super.secureStorage,
  }) : super(
          storageKey: 'ion_identity_client_private_keys_key',
          // fromJson: Assuming the stored map looks like {"value": "the_private_key"}
          fromJson: (json) => json['value'] as String,
          // toJson: Convert the string into a map {"value": stringValue}
          toJson: (value) => {'value': value},
        );

  String? getPrivateKey({required String username}) => super.getData(key: username);

  Future<void> setPrivateKey({required String username, required String privateKey}) =>
      super.setData(key: username, value: privateKey);

  Future<void> removePrivateKey({required String username}) => super.removeData(key: username);

  Future<void> clearAllPrivateKeys() => super.clearAllData();
}
