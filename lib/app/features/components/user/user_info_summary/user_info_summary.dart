// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/user/user_info_summary/user_info_tile.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
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

    final random = Random();
    final technology = useMemoized(() => random.nextBool() ? 'Technology' : null, []);
    final date = useMemoized(() => random.nextBool() ? 'October 2024' : null, []);
    final address = useMemoized(() => random.nextBool() ? 'Vienna, Austria' : null, []);
    final website = userMetadataValue.data.website;

    final tiles = <Widget>[];

    if (technology != null && technology.isNotEmpty) {
      tiles.add(
        UserInfoTile(
          title: technology,
          assetName: Assets.svg.iconBlockchain,
        ),
      );
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

    if (date != null && date.isNotEmpty) {
      tiles.add(
        UserInfoTile(
          title: date,
          assetName: Assets.svg.iconFieldCalendar,
        ),
      );
    }

    if (address != null && address.isNotEmpty) {
      tiles.add(
        UserInfoTile(
          title: address,
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
