// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/components/biometrics/suggest_to_add_biometrics_popup.dart';
import 'package:ion/app/features/user/providers/biometrics_provider.c.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion_identity_client/ion_identity.dart';

Future<void> Function(String username) useOnSuggestToAddBiometrics(WidgetRef ref) {
  final context = useContext();
  return useCallback(
    (String username) async {
      final userBiometricsState =
          await ref.read(userBiometricsStateProvider(username: username).future);
      if (userBiometricsState == BiometricsState.canSuggest && context.mounted) {
        await showSimpleBottomSheet<void>(
          context: context,
          child: SuggestToAddBiometricsPopup(username: username),
        );
      }
    },
    [context],
  );
}
