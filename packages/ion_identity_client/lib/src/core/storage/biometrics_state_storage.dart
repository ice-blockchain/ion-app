// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion_identity_client/src/core/storage/data_storage.dart';
import 'package:ion_identity_client/src/core/types/biometrics_state.dart';

class BiometricsStateStorage extends DataStorage<BiometricsState> {
  BiometricsStateStorage({
    required super.secureStorage,
  }) : super(
          storageKey: 'ion_identity_client_biometrics_state_key',
          fromJson: (json) {
            final value = json['value'] as String;
            return BiometricsState.values.firstWhere((e) => e.name == value);
          },
          toJson: (value) => {'value': value.name},
        );

  BiometricsState? getBiometricsState({required String username}) => super.getData(key: username);

  Future<void> updateBiometricsState({
    required String username,
    required BiometricsState biometricsState,
  }) =>
      super.setData(key: username, value: biometricsState);

  Future<void> removeBiometricsState({required String username}) => super.removeData(key: username);

  Future<void> clearAllPrivateKeys() => super.clearAllData();
}
