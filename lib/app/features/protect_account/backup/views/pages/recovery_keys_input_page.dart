// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/features/auth/views/components/recovery_keys_input_container/recovery_keys_input_container.dart';
import 'package:ice/app/router/app_routes.dart';

class RecoveryKeysInputPage extends StatelessWidget {
  const RecoveryKeysInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RecoveryKeysInputContainer(
      onContinuePressed: () => RecoveryKeysSuccessRoute().push<void>(context),
    );
  }
}
