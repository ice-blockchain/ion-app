// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/text_span_builder/hooks/use_text_span_builder.dart';
import 'package:ion/app/components/text_span_builder/text_span_builder.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_body/components/post_media/post_media.dart';
import 'package:ion/app/features/feed/views/components/url_preview_content/url_preview_content.dart';
import 'package:ion/app/features/ion_connect/model/entity_data_with_media_content.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';

class PostBody extends HookConsumerWidget {
  const PostBody({
    required this.entity,
    this.isTextSelectable = false,
    super.key,
  });

  final IonConnectEntity entity;
  final bool isTextSelectable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postData = switch (entity) {
      final ModifiablePostEntity post => post.data,
      final PostEntity post => post.data,
      _ => null,
    };

    if (postData is! EntityDataWithMediaContent) {
      return const SizedBox.shrink();
    }

    final textSpanBuilder = useTextSpanBuilder(
      context,
      defaultStyle: context.theme.appTextThemes.body2.copyWith(
        color: context.theme.appColors.sharkText,
      ),
    );

    final postText = textSpanBuilder.build(
      postData.contentWithoutMedia,
      onTap: (match) => TextSpanBuilder.defaultOnTap(context, match: match),
    );

    final postMedia = postData.media.values.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (postText.toPlainText().isNotEmpty)
          isTextSelectable ? SelectableText.rich(postText) : Text.rich(postText),
        if (postMedia.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 10.0.s),
            child: PostMedia(media: postMedia),
          ),
        if (postData.firstUrl != null)
          Padding(
            padding: EdgeInsets.only(top: 10.0.s),
            child: UrlPreviewContent(url: postData.firstUrl!),
          ),
      ],
    );
  }
}
