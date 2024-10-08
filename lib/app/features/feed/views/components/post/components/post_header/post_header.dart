// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/skeleton/skeleton.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/user/providers/user_data_provider.dart';
import 'package:ice/app/utils/username.dart';

class PostHeader extends ConsumerWidget {
  const PostHeader({
    required this.pubkey,
    super.key,
    this.trailing,
  });

  final Widget? trailing;

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider(pubkey));

    return Padding(
      padding: EdgeInsets.only(top: 12.0.s, bottom: 10.0.s),
      child: userData.maybeWhen(
        data: (userData) {
          return ListItem.user(
            title: Text(userData.displayName),
            subtitle: Text(prefixUsername(username: userData.name, context: context)),
            profilePicture: userData.picture,
            trailing: trailing,
            iceBadge: Random().nextBool(),
            verifiedBadge: Random().nextBool(),
            ntfAvatar: Random().nextBool(),
          );
        },
        orElse: () => const Skeleton(child: ListItemUserShape()),
      ),
    );
  }
}
