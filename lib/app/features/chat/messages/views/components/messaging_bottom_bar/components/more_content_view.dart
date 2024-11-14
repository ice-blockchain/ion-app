// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/providers/messaging_bottom_bar_state_provider.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/services/logger/logger.dart';
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
              _MoreContentItem(
                iconPath: Assets.svg.walletChatPhotos,
                title: context.i18n.common_photos,
                onTap: () {},
              ),
              _MoreContentItem(
                iconPath: Assets.svg.walletChatCamera,
                title: context.i18n.common_camera,
                onTap: () {},
              ),
              _MoreContentItem(
                iconPath: Assets.svg.walletChatIonpay,
                title: context.i18n.common_ion_pay,
                onTap: () {},
              ),
            ],
          ),
          SizedBox(height: 30.0.s),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MoreContentItem(
                iconPath: Assets.svg.walletChatPerson,
                title: context.i18n.common_profile,
                onTap: () async {
                  final contactId = await ShareProfileModalRoute(
                    title: context.i18n.chat_profile_share_modal_title,
                  ).push<String>(context);

                  //TODO: use contactId to share profile
                  Logger.log(contactId ?? 'No contact selected');

                  ref.read(messagingBottomBarActiveStateProvider.notifier).setText();
                },
              ),
              _MoreContentItem(
                iconPath: Assets.svg.walletChatDocument,
                title: context.i18n.common_document,
                onTap: () {},
              ),
              _MoreContentItem(
                iconPath: Assets.svg.walletChatPoll,
                title: context.i18n.common_poll,
                onTap: () {
                  ChatAddPollModalRoute().push<void>(context);
                  ref.read(messagingBottomBarActiveStateProvider.notifier).setText();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MoreContentItem extends StatelessWidget {
  const _MoreContentItem({
    required this.iconPath,
    required this.title,
    required this.onTap,
  });

  final String iconPath;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          iconPath.icon(
            size: 48.0.s,
          ),
          SizedBox(width: 8.0.s),
          Text(
            title,
            style: context.theme.appTextThemes.body2,
          ),
        ],
      ),
    );
  }
}
