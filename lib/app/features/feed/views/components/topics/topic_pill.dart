// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';

class TopicPill extends HookConsumerWidget {
  const TopicPill({
    required this.topic,
    super.key,
  });

  final String topic;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.0.s),
        color: context.theme.appColors.primaryBackground,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.s, horizontal: 6.s),
        child: Text(
          topic,
          style: context.theme.appTextThemes.caption2.copyWith(
            color: context.theme.appColors.primaryAccent,
          ),
          textHeightBehavior: const TextHeightBehavior(
            applyHeightToFirstAscent: false,
          ),
        ),
      ),
    );
  }
}
