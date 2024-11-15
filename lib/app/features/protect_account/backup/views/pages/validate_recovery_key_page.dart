// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/views/components/recovery_keys_input_container/recovery_keys_input_container.dart';
import 'package:ion/app/features/protect_account/backup/data/models/recovery_key_property.dart';
import 'package:ion/app/features/protect_account/backup/providers/create_recovery_key_action_notifier.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion_identity_client/ion_identity.dart';

class ValidateRecoveryKeyPage extends ConsumerWidget {
  const ValidateRecoveryKeyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recoveryResult = ref.watch(createRecoveryKeyActionNotifierProvider).requireValue;

    return RecoveryKeysInputContainer(
      validator: (value, property) => _validateProperty(value, property, recoveryResult!),
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
