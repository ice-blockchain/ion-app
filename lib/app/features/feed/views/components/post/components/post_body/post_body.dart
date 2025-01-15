// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/text_span_builder/hooks/use_text_span_builder.dart';
import 'package:ion/app/components/text_span_builder/text_span_builder.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_body/components/post_media/post_media.dart';

class PostBody extends HookConsumerWidget {
  const PostBody({
    required this.postEntity,
    super.key,
  });

  final PostEntity postEntity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    final processedPostText = useMemoized(
      () => _postProcessTextSpan(postText),
      [postText],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text.rich(
          postMedia.isNotEmpty ? processedPostText : postText,
        ),
        if (postMedia.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(
              top: 10.0.s,
            ),
            child: PostMedia(media: postMedia),
          ),
      ],
    );
  }

  // Post-process text span to remove leading space
  TextSpan _postProcessTextSpan(TextSpan postText) {
    final children = postText.children;
    if (children == null || children.isEmpty) return postText;

    final firstSpan = children.first;
    if (firstSpan is! TextSpan) return postText;

    final text = firstSpan.text;
    if (text == null || !text.startsWith(' ')) return postText;

    children[0] = TextSpan(
      text: text.substring(1),
      style: firstSpan.style,
      recognizer: firstSpan.recognizer,
    );

    return postText;
  }
}
