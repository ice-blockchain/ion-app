// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/text_span_builder/hooks/use_text_span_builder.dart';
import 'package:ion/app/components/text_span_builder/text_span_builder.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_body/components/post_media/post_media.dart';
import 'package:ion/app/features/feed/views/components/url_preview_content/url_preview_content.dart';

class PostBody extends HookConsumerWidget {
  const PostBody({
    required this.postEntity,
    this.isTextSelectable = false,
    super.key,
  });

  final ModifiablePostEntity postEntity;
  final bool isTextSelectable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelectionEnabled = useState(false);
    final postMedia = postEntity.data.media.values.toList();

    final textSpanBuilder = useTextSpanBuilder(
      context,
      defaultStyle: context.theme.appTextThemes.body2.copyWith(
        color: context.theme.appColors.sharkText,
      ),
    );

    final postText = textSpanBuilder.build(
      postEntity.data.contentWithoutMedia,
      onTap: (match) => TextSpanBuilder.defaultOnTap(context, match: match),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (postText.toPlainText().isNotEmpty)
          GestureDetector(
            onLongPress: isTextSelectable ? () => isSelectionEnabled.value = true : null,
            child: isSelectionEnabled.value ? SelectableText.rich(postText) : Text.rich(postText),
          ),
        if (postMedia.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 10.0.s),
            child: PostMedia(media: postMedia),
          ),
        if (postEntity.data.firstUrl != null)
          Padding(
            padding: EdgeInsets.only(top: 10.0.s),
            child: UrlPreviewContent(url: postEntity.data.firstUrl!),
          ),
      ],
    );
  }
}
