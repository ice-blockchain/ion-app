// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/components/biometrics/suggest_to_add_biometrics_popup.dart';
import 'package:ion/app/features/user/providers/biometrics_provider.r.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion_identity_client/ion_identity.dart';

Future<void> Function({required String username, required String password})
    useOnSuggestToAddBiometrics(WidgetRef ref) {
  final context = useContext();
  return useCallback(
    ({
      required String username,
      required String password,
    }) async {
      final userBiometricsState =
          await ref.read(userBiometricsStateProvider(username: username).future);
      if (userBiometricsState == BiometricsState.canSuggest && context.mounted) {
        await showSimpleBottomSheet<void>(
          context: context,
          child: SuggestToAddBiometricsPopup(
            username: username,
            password: password,
          ),
        );
      }
    },
    [context],
  );
}
