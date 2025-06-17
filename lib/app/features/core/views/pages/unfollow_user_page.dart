// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/card/info_card.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/generated/assets.gen.dart';

class UnfollowUserModal extends ConsumerWidget {
  const UnfollowUserModal({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(userMetadataProvider(pubkey)).valueOrNull?.data.name ?? '';

    ref.displayErrors(followListManagerProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(start: 30.0.s, end: 30.0.s, top: 30.0.s),
          child: InfoCard(
            iconAsset: Assets.svgActionProfileUnfollow,
            title: context.i18n.profile_popup_unfollow(name),
            description: context.i18n.profile_popup_unfollow_desc,
          ),
        ),
        SizedBox(height: 24.0.s),
        ScreenSideOffset.small(
          child: Button(
            leadingIcon: IconAssetColored(
              Assets.svgIconCategoriesUnflow,
              color: context.theme.appColors.onPrimaryAccent,
            ),
            onPressed: () {
              rootNavigatorKey.currentState?.pop();
              ref.read(followListManagerProvider.notifier).toggleFollow(pubkey);
            },
            label: Text(context.i18n.button_unfollow),
            mainAxisSize: MainAxisSize.max,
          ),
        ),
        ScreenBottomOffset(),
      ],
    );
  }
}
