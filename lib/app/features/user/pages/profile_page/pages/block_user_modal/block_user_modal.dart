// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/card/info_card.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/generated/assets.gen.dart';

class BlockUserModal extends ConsumerWidget {
  const BlockUserModal({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(userMetadataProvider(pubkey)).valueOrNull?.name ?? '';
    final minSize = Size(56.0.s, 56.0.s);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 30.0.s, right: 30.0.s, top: 30.0.s),
          child: InfoCard(
            iconAsset: Assets.svg.actionProfileBlockuser,
            title: context.i18n.post_menu_block_nickname(name),
            description: context.i18n.profile_popup_block_user_desc,
          ),
        ),
        SizedBox(height: 50.0.s),
        ScreenSideOffset.small(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Button.compact(
                  type: ButtonType.outlined,
                  label: Text(context.i18n.button_cancel),
                  minimumSize: minSize,
                  onPressed: () => rootNavigatorKey.currentState?.pop(),
                ),
              ),
              SizedBox(
                width: 16.0.s,
              ),
              Expanded(
                child: Button.compact(
                  label: Text(context.i18n.button_block),
                  minimumSize: minSize,
                  backgroundColor: context.theme.appColors.attentionRed,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
        ScreenBottomOffset(),
      ],
    );
  }
}
