// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

final double moreContentHeight = 206.0.s;

class MoreContentView extends StatelessWidget {
  const MoreContentView({super.key});
  @override
  Widget build(BuildContext context) {
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
                onTap: () {},
              ),
              _MoreContentItem(
                iconPath: Assets.svg.walletChatDocument,
                title: context.i18n.common_document,
                onTap: () {},
              ),
              _MoreContentItem(
                iconPath: Assets.svg.walletChatPoll,
                title: context.i18n.common_poll,
                onTap: () {},
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
