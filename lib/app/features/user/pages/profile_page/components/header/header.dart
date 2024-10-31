// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/features/user/pages/components/header_action/header_action.dart';
import 'package:ion/app/features/user/pages/profile_page/components/header/context_menu.dart';
import 'package:ion/app/features/user/pages/profile_page/components/header/user_list_item.dart';
import 'package:ion/generated/assets.gen.dart';

class Header extends ConsumerWidget {
  const Header({
    required this.pubkey,
    required this.opacity,
    super.key,
  });

  final String pubkey;
  final double opacity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCurrentUserProfile = ref.watch(isCurrentUserSelectorProvider(pubkey));

    return ScreenTopOffset(
      child: ScreenSideOffset.small(
        child: SizedBox(
          height: HeaderAction.buttonSize,
          child: Row(
            children: [
              HeaderAction(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                assetName: Assets.svg.iconChatBack,
                opacity: opacity,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0.s),
                  child: Opacity(
                    opacity: opacity,
                    child: UseListItem(
                      pubkey: pubkey,
                      minHeight: HeaderAction.buttonSize,
                    ),
                  ),
                ),
              ),
              if (!isCurrentUserProfile)
                ContextMenu(
                  pubkey: pubkey,
                  opacity: opacity,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
