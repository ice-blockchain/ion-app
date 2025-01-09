// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/counter_items_footer/text_action_button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/providers/counters/reposted_events_provider.c.dart';
import 'package:ion/app/features/feed/providers/counters/reposts_count_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/utils/num.dart';
import 'package:ion/generated/assets.gen.dart';

class RepostsCounterButton extends ConsumerWidget {
  const RepostsCounterButton({
    required this.eventReference,
    this.color,
    super.key,
  });

  final EventReference eventReference;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repostsCount = ref.watch(repostsCountProvider(eventReference));
    final isReposted = ref.watch(isRepostedProvider(eventReference));

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        RepostOptionsModalRoute(eventReference: eventReference.toString()).push<void>(context);
      },
      child: TextActionButton(
        icon: Assets.svg.iconBlockRepost.icon(
          size: 16.0.s,
          color: color ?? context.theme.appColors.onTertararyBackground,
        ),
        textColor: color ?? context.theme.appColors.onTertararyBackground,
        activeIcon: Assets.svg.iconBlockRepost.icon(
          size: 16.0.s,
          color: context.theme.appColors.primaryAccent,
        ),
        activeTextColor: context.theme.appColors.primaryAccent,
        value: repostsCount != null ? formatDoubleCompact(repostsCount) : '',
        isActive: isReposted,
      ),
    );
  }
}
