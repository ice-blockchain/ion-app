// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/feature_flags.dart';
import 'package:ion/app/features/core/providers/feature_flags_provider.c.dart';
import 'package:ion/generated/assets.gen.dart';

class NoUserView extends ConsumerWidget {
  const NoUserView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hideCommunity =
        ref.watch(featureFlagsProvider.notifier).get(HideCommunityFeatureFlag.hideCommunity);

    return Expanded(
      child: ScreenSideOffset.small(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Assets.svg.walletChatNewchat.icon(
              size: 48.0.s,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0.s, horizontal: 78.0.s),
              child: Text(
                hideCommunity
                    ? context.i18n.new_chat_modal_no_community_description
                    : context.i18n.new_chat_modal_description,
                style: context.theme.appTextThemes.caption2.copyWith(
                  color: context.theme.appColors.onTertararyBackground,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}
