// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/text_editor/text_editor_preview.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_body/components/post_media/post_media.dart';
import 'package:ion/app/features/ion_connect/model/entity_data_with_media_content.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/views/hooks/use_content_without_media.dart';

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

    final content = useContentWithoutMedia(data: postData);

    final postMedia = postData.media.values.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (content.isNotEmpty) TextEditorPreview(content: content),
        if (postMedia.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 10.0.s),
            child: PostMedia(media: postMedia),
          ),
        //TODO::impl
        // if (postData.firstUrl != null)
        //   Padding(
        //     padding: EdgeInsets.only(top: 10.0.s),
        //     child: UrlPreviewContent(url: postData.firstUrl!),
        //   ),
      ],
    );
  }
}
