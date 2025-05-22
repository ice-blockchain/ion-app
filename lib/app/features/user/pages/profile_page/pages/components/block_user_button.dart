// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/block_user_modal/block_user_modal.dart';
import 'package:ion/app/features/user_block/providers/block_list_notifier.c.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';

class BlockUserButton extends ConsumerWidget {
  const BlockUserButton({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocking = ref.watch(isBlockedProvider(pubkey));
    return _BlockButton(
      onPressed: () {
        if (!blocking) {
          showSimpleBottomSheet<void>(
            context: context,
            child: BlockUserModal(
              pubkey: pubkey,
            ),
          );
        } else {
          ref.read(blockListNotifierProvider.notifier).toggleBlocked(pubkey);
        }
      },
      blocking: blocking,
    );
  }
}

class _BlockButton extends StatelessWidget {
  const _BlockButton({
    required this.onPressed,
    required this.blocking,
  });

  final VoidCallback onPressed;
  final bool blocking;

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: onPressed,
      leadingIcon:
          (blocking ? Assets.svg.iconProfileUnblock : Assets.svg.iconProfileBlockUser).icon(
        color: blocking
            ? context.theme.appColors.onPrimaryAccent
            : context.theme.appColors.attentionRed,
        size: 16.0.s,
      ),
      backgroundColor: blocking ? context.theme.appColors.attentionRed : null,
      type: blocking ? ButtonType.primary : ButtonType.outlined,
      tintColor: blocking ? null : context.theme.appColors.attentionRed,
      label: Text(
        blocking ? context.i18n.button_unblock : context.i18n.button_block,
        style: context.theme.appTextThemes.caption.copyWith(
          color: blocking
              ? context.theme.appColors.onPrimaryAccent
              : context.theme.appColors.attentionRed,
        ),
      ),
      leadingIconOffset: 2,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(103.0.s, 28.0.s),
        padding: EdgeInsets.symmetric(horizontal: 16.0.s),
      ),
    );
  }
}
