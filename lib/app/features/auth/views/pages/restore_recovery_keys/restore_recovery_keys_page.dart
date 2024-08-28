import 'package:flutter/material.dart';
import 'package:ice/app/features/auth/views/components/recovery_keys_input_container/recovery_keys_input_container.dart';
import 'package:ice/app/router/app_routes.dart';

class RestoreRecoveryKeysPage extends StatelessWidget {
  const RestoreRecoveryKeysPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RecoveryKeysInputContainer(
      onContinuePressed: () => TwoFaOptionsRoute().push<void>(context),
    );
  }
}
