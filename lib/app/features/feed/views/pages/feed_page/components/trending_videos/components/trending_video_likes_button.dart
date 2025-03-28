// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/feed/providers/counters/likes_count_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/utils/num.dart';
import 'package:ion/generated/assets.gen.dart';

class TrendingVideoLikesButton extends ConsumerWidget {
  const TrendingVideoLikesButton({
    required this.eventReference,
    super.key,
  });

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likesCount = ref.watch(likesCountProvider(eventReference));

    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 12.0.s),
      ),
      onPressed: () {},
      child: Row(
        children: [
          Assets.svg.iconVideoLikeOn.icon(
            size: 14.0.s,
            color: context.theme.appColors.secondaryBackground,
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 2.0.s),
            child: Text(
              formatDoubleCompact(likesCount),
              style: context.theme.appTextThemes.caption3.copyWith(
                color: context.theme.appColors.secondaryBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
