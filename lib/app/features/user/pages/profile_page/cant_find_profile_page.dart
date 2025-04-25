// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/empty_list/empty_list.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/pages/components/header_action/header_action.dart';
import 'package:ion/app/features/user/pages/components/profile_avatar/profile_avatar.dart';
import 'package:ion/generated/assets.gen.dart';

class CantFindProfilePage extends StatelessWidget {
  const CantFindProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.theme.appColors.secondaryBackground;

    return Scaffold(
      body: ColoredBox(
        color: backgroundColor,
        child: SafeArea(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              ScreenTopOffset(
                child: Column(
                  children: [
                    const ProfileAvatar(pubkey: ''),
                    Expanded(
                      child: EmptyList(
                        asset: Assets.svg.walletIconProfileMissingprofile,
                        title: context.i18n.profile_no_account_found,
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Padding(
                  padding: EdgeInsetsDirectional.only(
                    top: 17.0.s,
                  ),
                  child: ScreenSideOffset.small(
                    child: HeaderAction(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      assetName: Assets.svg.iconProfileBack,
                      opacity: 1,
                      flipForRtl: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
