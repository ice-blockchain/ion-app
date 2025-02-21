// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/views/components/user_info/user_info.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';

class VideoPostInfo extends ConsumerWidget {
  const VideoPostInfo({
    required this.eventReference,
    super.key,
  });

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postEntity = ref.watch(ionConnectEntityProvider(eventReference: eventReference));
    final post = postEntity.valueOrNull as ModifiablePostEntity?;

    final shadow = [
      Shadow(
        offset: Offset(0.0.s, 1.5.s),
        blurRadius: 1.5,
        color: context.theme.appColors.primaryText.withValues(alpha: 0.25),
      ),
    ];

    final textStyle = context.theme.appTextThemes.subtitle3.copyWith(
      color: context.theme.appColors.onPrimaryAccent,
      shadows: shadow,
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 12.0.s,
        horizontal: 16.0.s,
      ),
      child: UserInfo(
        pubkey: eventReference.pubkey,
        createdAt: post?.data.publishedAt.value,
        textStyle: textStyle,
      ),
    );
  }
}
