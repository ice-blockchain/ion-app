// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/search/views/components/advanced_search_groups/advanced_search_group_list_item.dart';
import 'package:ion/app/features/search/views/components/search_sub_header/search_sub_header.dart';
import 'package:ion/generated/assets.gen.dart';

class AdvancedSearchChannels extends HookConsumerWidget {
  const AdvancedSearchChannels({required this.query, super.key});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 16.0.s),
            child: SearchSubHeader(
              icon: Assets.svg.iconCategoriesFollowing,
              title: context.i18n.chat_groups_subscribed,
              count: 4,
            ),
          ),
          ListView.builder(
            itemCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  if (index == 0)
                    SizedBox(
                      height: 12.0.s,
                    ),
                  const AdvancedSearchGroupListItem(
                    avatarUrl:
                        'https://ice-staging.b-cdn.net/profile/default-profile-picture-15.png',
                    displayName: 'ICE Coin crypto',
                    message: 'Exploring the intersection of finance and technology.',
                    joined: false,
                    isVerified: true,
                    isIon: true,
                  ),
                  HorizontalSeparator(
                    height: 16.0.s,
                  ),
                ],
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0.s),
            child: SearchSubHeader(
              icon: Assets.svg.iconSendfundsUser,
              title: context.i18n.chat_groups_explore,
              count: 4,
            ),
          ),
          ListView.builder(
            itemCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  if (index == 0)
                    SizedBox(
                      height: 12.0.s,
                    ),
                  const AdvancedSearchGroupListItem(
                    avatarUrl:
                        'https://ice-staging.b-cdn.net/profile/default-profile-picture-14.png',
                    displayName: 'Trending Crypto Apps',
                    message: '10,000',
                    joined: true,
                  ),
                  HorizontalSeparator(
                    height: 16.0.s,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
