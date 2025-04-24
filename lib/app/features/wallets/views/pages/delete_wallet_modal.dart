// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/wallets/providers/delete_wallet_view_provider.c.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class DeleteWalletModal extends ConsumerWidget {
  const DeleteWalletModal({required this.walletId, super.key});

  final String walletId;

  static double get buttonsSize => 56.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonMinimalSize = Size(buttonsSize, buttonsSize);

    final isDeleting =
        ref.watch(deleteWalletViewNotifierProvider(walletViewId: walletId)).isLoading;

    return SheetContent(
      body: ScreenSideOffset.small(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(top: 31.0.s, bottom: 4.0.s),
              child: Assets.svg.actionWalletDelete.icon(size: 80.0.s),
            ),
            Text(
              context.i18n.wallet_delete_q,
              style: context.theme.appTextThemes.title.copyWith(
                color: context.theme.appColors.primaryText,
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(
                top: 8.0.s,
                bottom: 30.0.s,
                start: 36.0.s,
                end: 36.0.s,
              ),
              child: Text(
                context.i18n.wallet_delete_message,
                style: context.theme.appTextThemes.body2.copyWith(
                  color: context.theme.appColors.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Button.compact(
                    type: ButtonType.outlined,
                    label: Text(
                      context.i18n.button_cancel,
                    ),
                    onPressed: () {
                      context.pop();
                    },
                    minimumSize: buttonMinimalSize,
                  ),
                ),
                SizedBox(
                  width: 15.0.s,
                ),
                Expanded(
                  child: Button.compact(
                    label: Text(context.i18n.button_delete),
                    disabled: isDeleting,
                    trailingIcon: isDeleting ? const IONLoadingIndicator() : null,
                    onPressed: () async {
                      await ref
                          .read(deleteWalletViewNotifierProvider(walletViewId: walletId).notifier)
                          .delete();

                      if (context.mounted) {
                        context.pop();
                      }
                    },
                    minimumSize: buttonMinimalSize,
                    backgroundColor: context.theme.appColors.attentionRed,
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.paddingOf(context).bottom + 20.0.s),
          ],
        ),
      ),
    );
  }
}
