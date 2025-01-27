// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/counter_items_footer/likes_counter_button.dart';
import 'package:ion/app/components/counter_items_footer/replies_counter_button.dart';
import 'package:ion/app/components/counter_items_footer/reposts_counter_button.dart';
import 'package:ion/app/components/counter_items_footer/share_button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/entities_list/components/bookmark_button/bookmark_button.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';

class CounterItemsFooter extends HookConsumerWidget {
  CounterItemsFooter({
    required this.eventReference,
    this.repostReference,
    double? bottomPadding,
    double? topPadding,
    this.color,
    super.key,
  })  : bottomPadding = bottomPadding ?? 16.0.s,
        topPadding = topPadding ?? 10.0.s;

  final EventReference eventReference;
  final EventReference? repostReference;
  final double bottomPadding;
  final double topPadding;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding, top: topPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: RepliesCounterButton(
              eventReference: eventReference,
              color: color,
            ),
          ),
          Flexible(
            child: RepostsCounterButton(
              eventReference: eventReference,
              repostReference: repostReference,
              color: color,
            ),
          ),
          Flexible(
            child: LikesCounterButton(
              eventReference: eventReference,
              color: color,
            ),
          ),
          BookmarkButton(
            eventReference: eventReference,
            iconSize: 16.0.s,
            colorFilter:
                ColorFilter.mode(context.theme.appColors.onTertararyBackground, BlendMode.srcIn),
          ),
          ShareButton(
            eventReference: eventReference,
            color: color,
          ),
        ],
      ),
    );
  }
}
