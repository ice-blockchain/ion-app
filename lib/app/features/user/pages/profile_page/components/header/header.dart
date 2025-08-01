// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/features/user/pages/components/header_action/header_action.dart';
import 'package:ion/app/features/user/pages/profile_page/components/header/user_list_item.dart';

class Header extends ConsumerWidget {
  const Header({
    required this.pubkey,
    required this.opacity,
    required this.showBackButton,
    super.key,
  });

  final String pubkey;
  final double opacity;
  final bool showBackButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenTopOffset(
      child: SizedBox(
        height: HeaderAction.buttonSize,
        child: Opacity(
          opacity: opacity,
          child: UseListItem(
            pubkey: pubkey,
            minHeight: HeaderAction.buttonSize,
          ),
        ),
      ),
    );
  }
}
