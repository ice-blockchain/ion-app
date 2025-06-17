// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/modal_sheets/simple_modal_sheet.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/verify_identity/verify_identity_prompt_dialog_helper.dart';
import 'package:ion/app/features/feed/providers/delete_account_notifier.c.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:ion_identity_client/ion_identity.dart';

class ConfirmDeleteModal extends HookConsumerWidget {
  const ConfirmDeleteModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonMinimalSize = Size(56.0.s, 56.0.s);

    final processing = useState<bool>(false);

    ref.displayErrors(deleteAccountNotifierProvider);

    return SimpleModalSheet.alert(
      isBottomSheet: true,
      iconAsset: Assets.svgactionCreatepostDeleterole,
      title: context.i18n.confirm_delete_title,
      description: context.i18n.confirm_delete_description,
      button: ScreenSideOffset.small(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Button.compact(
                disabled: processing.value,
                type: ButtonType.outlined,
                label: Text(context.i18n.button_cancel),
                onPressed: context.pop,
                minimumSize: buttonMinimalSize,
              ),
            ),
            SizedBox(width: 15.0.s),
            Expanded(
              child: Button.compact(
                disabled: processing.value,
                trailingIcon: processing.value ? const IONLoadingIndicator() : null,
                label: Text(context.i18n.button_delete),
                onPressed: () async {
                  try {
                    processing.value = true;
                    await guardPasskeyDialog(
                      context,
                      (child) => RiverpodVerifyIdentityRequestBuilder(
                        requestWithVerifyIdentity: (
                          OnVerifyIdentity<GenerateSignatureResponse> onVerifyIdentity,
                        ) {
                          ref
                              .read(deleteAccountNotifierProvider.notifier)
                              .deleteAccount(onVerifyIdentity);
                        },
                        provider: deleteAccountNotifierProvider,
                        child: child,
                      ),
                    );
                  } finally {
                    processing.value = false;
                  }
                },
                minimumSize: buttonMinimalSize,
                backgroundColor: context.theme.appColors.attentionRed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
