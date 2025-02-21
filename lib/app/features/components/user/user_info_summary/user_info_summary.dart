// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/user/user_info_summary/user_info_tile.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.c.dart';
import 'package:ion/app/features/user/providers/user_categories_provider.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/utils/date.dart';
import 'package:ion/generated/assets.gen.dart';

class UserInfoSummary extends HookConsumerWidget {
  const UserInfoSummary({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadataValue = ref.watch(userMetadataProvider(pubkey)).valueOrNull;
    final isCurrentUserFollowed = ref.watch(isCurrentUserFollowedProvider(pubkey));

    if (userMetadataValue == null) {
      return const SizedBox.shrink();
    }

    final UserMetadata(:website, :registeredAt, :location, :category) = userMetadataValue.data;

    final tiles = <Widget>[];

    if (category != null) {
      tiles.add(_CategoryTile(category: category));
    }

    if (website != null && website.isNotEmpty) {
      tiles.add(
        UserInfoTile(
          title: website,
          assetName: Assets.svg.iconArticleLink,
          isLink: true,
        ),
      );
    }

    if (registeredAt != null) {
      tiles.add(
        UserInfoTile(
          title: formatDateToMonthYear(registeredAt),
          assetName: Assets.svg.iconFieldCalendar,
        ),
      );
    }

    if (location != null && location.isNotEmpty) {
      tiles.add(
        UserInfoTile(
          title: location,
          assetName: Assets.svg.iconProfileLocation,
        ),
      );
    }

    if (isCurrentUserFollowed) {
      tiles.add(
        UserInfoTile(
          title: context.i18n.profile_follows_you,
          assetName: Assets.svg.iconSearchFollow,
        ),
      );
    }

    if (tiles.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: 8.0.s,
        runSpacing: 4.0.s,
        children: tiles,
      ),
    );
  }
}

class _CategoryTile extends ConsumerWidget {
  const _CategoryTile({required this.category});

  final String category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(userCategoriesProvider).valueOrNull;
    final label =
        categories != null && categories.containsKey(category) ? categories[category]!.name : null;

    if (label == null) return const SizedBox.shrink();

    return UserInfoTile(
      title: label,
      assetName: Assets.svg.iconBlockchain,
    );
  }
}
