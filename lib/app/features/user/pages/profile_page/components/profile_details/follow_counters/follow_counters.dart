// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/model/follow_type.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/follow_counters/follow_counters_cell.dart';

class FollowCounters extends ConsumerWidget {
  const FollowCounters({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 36.0.s,
      decoration: BoxDecoration(
        color: context.theme.appColors.tertararyBackground,
        borderRadius: BorderRadius.circular(16.0.s),
      ),
      child: Row(
        children: [
          Expanded(
            child: FollowCountersCell(
              pubkey: pubkey,
              followType: FollowType.following,
            ),
          ),
          VerticalDivider(
            width: 1.0.s,
            thickness: 0.5.s,
            indent: 8.0.s,
            endIndent: 8.0.s,
            color: context.theme.appColors.onTerararyFill,
          ),
          Expanded(
            child: FollowCountersCell(
              pubkey: pubkey,
              followType: FollowType.followers,
            ),
          ),
        ],
      ),
    );
  }
}
