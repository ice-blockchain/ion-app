// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/local_passkey_creds_provider.r.dart';
import 'package:ion/app/features/components/passkey/suggest_to_create_local_passkey_creds_popup.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion_identity_client/ion_identity.dart';

Future<void> Function(String username) useOnSuggestToCreateLocalPasskeyCreds(WidgetRef ref) {
  final context = useContext();
  return useCallback(
    (String username) async {
      final userLocalPasskeyCredsState =
          await ref.read(userLocalPasskeyCredsStateProvider(username: username).future);
      if (userLocalPasskeyCredsState == LocalPasskeyCredsState.canSuggest && context.mounted) {
        await showSimpleBottomSheet<void>(
          context: context,
          child: SuggestToCreateLocalPasskeyCredsPopup(username: username),
        );
      }
    },
    [context],
  );
}
