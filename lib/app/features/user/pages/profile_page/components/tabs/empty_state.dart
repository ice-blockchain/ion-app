// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/empty_list/empty_list.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/features/user/data/models/tab_entity_type.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.type,
    required this.isCurrentUserProfile,
    required this.username,
    super.key,
  });

  final TabEntityType type;
  final bool isCurrentUserProfile;
  final String username;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: ScreenSideOffset.small(
        child: EmptyList(
          asset: type.emptyStateIconAsset,
          title: isCurrentUserProfile
              ? type.getEmptyStateTitleForCurrentUser(context)
              : type.getEmptyStateTitle(context, username),
        ),
      ),
    );
  }
}
