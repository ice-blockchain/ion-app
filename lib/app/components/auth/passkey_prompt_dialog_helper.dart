import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/auth/passkey_prompt_dialog.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';

Future<void> guardPasskeyDialog(
  BuildContext context,
  ProviderListenable<AsyncValue<void>> provider,
  VoidCallback onInit,
) async {
  return showSimpleBottomSheet<void>(
    context: context,
    child: PasskeyPromptDialog(
      onInit: onInit,
      provider: provider,
    ),
  );
}
