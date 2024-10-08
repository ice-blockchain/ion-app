// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/auth/views/components/recovery_keys_input_container/recovery_keys_input_container.dart';
import 'package:ice/app/features/protect_account/backup/data/models/recovery_key_property.dart';
import 'package:ice/app/features/protect_account/backup/data/providers/recovery_key_data_provider.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ion_identity_client/ion_client.dart';

class ValidateRecoveryKeyPage extends ConsumerWidget {
  const ValidateRecoveryKeyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recoveryData = ref.watch(recoveryKeyDataProvider).requireValue;

    return RecoveryKeysInputContainer(
      validator: (value, property) => _validateProperty(value, property, recoveryData),
      onContinuePressed: (_, __, ___) => RecoveryKeysSuccessRoute().push<void>(context),
    );
  }

  String? _validateProperty(
    String? inputValue,
    RecoveryKeyProperty property,
    CreateRecoveryCredentialsSuccess recoveryData,
  ) {
    final propertyValue = switch (property) {
      RecoveryKeyProperty.identityKeyName => recoveryData.identityKeyName,
      RecoveryKeyProperty.recoveryKeyId => recoveryData.recoveryKeyId,
      RecoveryKeyProperty.recoveryCode => recoveryData.recoveryCode,
    };

    return inputValue == propertyValue ? null : '';
  }
}
