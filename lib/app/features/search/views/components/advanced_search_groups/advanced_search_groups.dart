// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/search/views/components/advanced_search_groups/advanced_search_group_list_item.dart';
import 'package:ion/app/features/search/views/components/search_sub_header/search_sub_header.dart';
import 'package:ion/generated/assets.gen.dart';

class AdvancedSearchGroups extends HookConsumerWidget {
  const AdvancedSearchGroups({required this.query, super.key});

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
              icon: Assets.svg.iconSearchJoined,
              title: context.i18n.chat_groups_joined,
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
                        'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
                    displayName: 'HOT Crypto Updates',
                    message: 'Interesting statistics on the mass distribution of cryptocurrencies.',
                    joined: false,
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
