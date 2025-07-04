// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/early_access_provider.r.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion_identity_client/ion_identity.dart';

ValueNotifier<String?> useVerifyEmailEarlyAccessErrorMessage(WidgetRef ref) {
  final context = useContext();
  final state = ref.watch(earlyAccessNotifierProvider);
  ref.displayErrors(
    earlyAccessNotifierProvider,
    excludedExceptions: {InvalidEmailException},
  );

  final errorMessage = useState<String?>(null);
  useOnInit(
    () {
      if (state.hasError && !state.isLoading) {
        if (state.error is InvalidEmailException) {
          errorMessage.value = context.i18n.error_invalid_email;
        }
      }
    },
    [state.hasError, state.isLoading],
  );

  return errorMessage;
}
