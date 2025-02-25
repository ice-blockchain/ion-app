// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/text_editor/text_editor_preview.dart';
import 'package:ion/app/components/text_editor/utils/text_editor_styles.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/views/components/user_info/user_info.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/features/ion_connect/views/hooks/use_parsed_media_content.dart';

class VideoPostInfo extends HookConsumerWidget {
  const VideoPostInfo({
    required this.eventReference,
    super.key,
  });

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postEntity = ref.watch(ionConnectEntityProvider(eventReference: eventReference));
    final post = postEntity.valueOrNull as ModifiablePostEntity?;

    if (post == null) return const SizedBox.shrink();

    final (:content, :media) = useParsedMediaContent(data: post.data);

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

    final postTextStyle = context.theme.appTextThemes.body2.copyWith(
      color: context.theme.appColors.onPrimaryAccent,
      shadows: shadow,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserInfo(
          pubkey: eventReference.pubkey,
          createdAt: post.data.publishedAt.value,
          textStyle: textStyle,
        ),
        if (content.isNotEmpty) ...[
          SizedBox(height: 8.0.s),
          TextEditorPreview(
            content: content,
            customStyles: textEditorStyles(context).merge(
              DefaultStyles(
                paragraph: DefaultTextBlockStyle(
                  postTextStyle,
                  HorizontalSpacing.zero,
                  VerticalSpacing.zero,
                  VerticalSpacing.zero,
                  const BoxDecoration(),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
