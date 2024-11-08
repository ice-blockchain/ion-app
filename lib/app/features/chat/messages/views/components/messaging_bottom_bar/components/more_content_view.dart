// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/providers/messaging_bottom_bar_state_provider.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/generated/assets.gen.dart';

final double moreContentHeight = 206.0.s;

class MoreContentView extends ConsumerWidget {
  const MoreContentView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: moreContentHeight,
      width: double.infinity,
      color: context.theme.appColors.secondaryBackground,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Assets.svg.walletChatPhotos.icon(
                    size: 48.0.s,
                  ),
                  SizedBox(width: 8.0.s),
                  Text(
                    context.i18n.common_photos,
                    style: context.theme.appTextThemes.body2,
                  ),
                ],
              ),
              Column(
                children: [
                  Assets.svg.walletChatCamera.icon(
                    size: 48.0.s,
                  ),
                  SizedBox(width: 8.0.s),
                  Text(
                    context.i18n.common_camera,
                    style: context.theme.appTextThemes.body2,
                  ),
                ],
              ),
              Column(
                children: [
                  Assets.svg.walletChatIonpay.icon(
                    size: 48.0.s,
                  ),
                  SizedBox(width: 8.0.s),
                  Text(
                    context.i18n.common_ion_pay,
                    style: context.theme.appTextThemes.body2,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 30.0.s),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  ShareProfileModalRoute().push<void>(context).then((value) {
                    ref.read(messagingBottomBarActiveStateProvider.notifier).setText();
                  });
                },
                child: Column(
                  children: [
                    Assets.svg.walletChatPerson.icon(
                      size: 48.0.s,
                    ),
                    SizedBox(width: 8.0.s),
                    Text(
                      context.i18n.common_profile,
                      style: context.theme.appTextThemes.body2,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Assets.svg.walletChatDocument.icon(
                    size: 48.0.s,
                  ),
                  SizedBox(width: 8.0.s),
                  Text(
                    context.i18n.common_document,
                    style: context.theme.appTextThemes.body2,
                  ),
                ],
              ),
              Column(
                children: [
                  Assets.svg.walletChatPoll.icon(
                    size: 48.0.s,
                  ),
                  SizedBox(width: 8.0.s),
                  Text(
                    context.i18n.common_poll,
                    style: context.theme.appTextThemes.body2,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
