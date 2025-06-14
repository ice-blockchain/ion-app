// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/components/topics/topic_pill.dart';

class TopicsCarousel extends ConsumerWidget {
  const TopicsCarousel({
    required this.topics,
    this.padding,
    super.key,
  });

  final List<String> topics;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (topics.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 24.0.s,
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: ScreenSideOffset.defaultMediumMargin),
          itemCount: topics.length,
          separatorBuilder: (context, index) => SizedBox(width: 12.0.s),
          itemBuilder: (context, index) => TopicPill(
            topic: topics[index],
          ),
        ),
      ),
    );
  }
}
