// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/empty_list/empty_list.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/generated/assets.gen.dart';

class EmptyState extends ConsumerWidget {
  const EmptyState({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: ScreenSideOffset.small(
        child: EmptyList(
          asset: Assets.svg.walletIconWalletEmptysearch,
          title: context.i18n.core_empty_search,
        ),
      ),
    );
  }
}
