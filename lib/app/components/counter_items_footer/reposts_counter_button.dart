// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/counter_items_footer/text_action_button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/throttled_provider.dart';
import 'package:ion/app/features/feed/providers/counters/reposted_events_provider.r.dart';
import 'package:ion/app/features/feed/providers/counters/reposts_count_provider.r.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/router/utils/quote_routing_utils.dart';
import 'package:ion/app/utils/num.dart';
import 'package:ion/generated/assets.gen.dart';

final _provider = Provider.family<({int? repostsCount, bool? isReposted}), EventReference>((ref, eventRef) {
  final repostsCount = ref.watch(repostsCountProvider(eventRef));
  final isReposted = ref.watch(isRepostedProvider(eventRef));
  return (repostsCount: repostsCount, isReposted: isReposted);
}).throttled();

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
    final value = ref.watch(_provider(eventReference)).valueOrNull;
    final repostsCount = value?.repostsCount ?? 0;
    final isReposted = value?.isReposted ?? false;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.lightImpact();
        QuoteRoutingUtils.pushRepostOptionsModal(context, eventReference.encode());
      },
      child: Container(
        constraints: BoxConstraints(minWidth: 50.0.s),
        alignment: Alignment.center,
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
          state: isReposted ? TextActionButtonState.active : TextActionButtonState.idle,
        ),
      ),
    );
  }
}
