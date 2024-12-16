// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/components/verify_identity/verify_identity_confirm_password_dialog.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';

Future<String?> Function() useOnGetPassword(BuildContext context) {
  return useCallback(
    () {
      if (context.mounted) {
        return showSimpleBottomSheet<String>(
          context: context,
          child: const VerifyIdentityConfirmPasswordDialog(),
        );
      }
      throw VerifyIdentityException();
    },
    [context],
  );
}
