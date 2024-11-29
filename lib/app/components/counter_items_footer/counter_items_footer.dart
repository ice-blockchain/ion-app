// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/counter_items_footer/likes_counter_button.dart';
import 'package:ion/app/components/counter_items_footer/replies_counter_button.dart';
import 'package:ion/app/components/counter_items_footer/reposts_counter_button.dart';
import 'package:ion/app/components/counter_items_footer/share_button.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/nostr/model/event_reference.dart';

class CounterItemsFooter extends HookConsumerWidget {
  CounterItemsFooter({
    required this.eventReference,
    double? bottomPadding,
    double? topPadding,
    this.color,
    super.key,
  })  : bottomPadding = bottomPadding ?? 16.0.s,
        topPadding = topPadding ?? 10.0.s;

  final EventReference eventReference;
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
              color: color,
            ),
          ),
          Flexible(
            child: LikesCounterButton(
              eventReference: eventReference,
              color: color,
            ),
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
