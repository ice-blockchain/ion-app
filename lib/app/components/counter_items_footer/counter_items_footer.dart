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
    double? bottomPadding,
    double? topPadding,
    this.color,
    super.key,
  })  : bottomPadding = bottomPadding ?? 12.0.s,
        topPadding = topPadding ?? 10.0.s;

  final EventReference eventReference;
  final double bottomPadding;
  final double topPadding;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding, top: topPadding),
      child: SizedBox(
        height: 28.0.s,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: RepliesCounterButton(
                eventReference: eventReference,
                color: color,
              ),
            ),
            Center(
              child: RepostsCounterButton(
                eventReference: eventReference,
                color: color,
              ),
            ),
            Center(
              child: LikesCounterButton(
                eventReference: eventReference,
                color: color,
              ),
            ),
            Center(
              child: Row(
                children: [
                  BookmarkButton(
                    eventReference: eventReference,
                    size: 16.0.s,
                    color: color ?? context.theme.appColors.onTertararyBackground,
                  ),
                  ShareButton(
                    eventReference: eventReference,
                    color: color,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
