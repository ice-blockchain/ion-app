// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user_block/optimistic_ui/block_user_provider.r.dart';
import 'package:ion/generated/assets.gen.dart';

class ChatBlockedUserBar extends ConsumerWidget {
  const ChatBlockedUserBar({
    required this.receiverMasterPubkey,
    super.key,
  });

  final String receiverMasterPubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 45.0.s,
      child: TextButton(
        onPressed: () {
          ref.read(toggleBlockNotifierProvider.notifier).toggle(receiverMasterPubkey);
        },
        style: TextButton.styleFrom(
          minimumSize: Size(0, 40.0.s),
          padding: EdgeInsetsDirectional.only(start: 8.0.s),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.svg.iconProfileBlockUser.icon(color: context.theme.appColors.primaryAccent),
            SizedBox(width: 6.0.s),
            Text(
              context.i18n.button_unblock,
              style: context.theme.appTextThemes.subtitle3
                  .copyWith(color: context.theme.appColors.primaryAccent),
            ),
          ],
        ),
      ),
    );
  }
}
