// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/features/user/pages/components/header_action/header_action.dart';
import 'package:ion/app/features/user/pages/profile_page/components/header/context_menu.dart';
import 'package:ion/generated/assets.gen.dart';

class Header extends ConsumerWidget {
  const Header({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCurrentUserProfile = ref.watch(isCurrentUserSelectorProvider(pubkey));

    return ScreenTopOffset(
      child: ScreenSideOffset.small(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderAction(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              assetName: Assets.svg.iconChatBack,
            ),
            const Spacer(),
            if (!isCurrentUserProfile)
              ContextMenu(
                pubkey: pubkey,
              ),
          ],
        ),
      ),
    );
  }
}
