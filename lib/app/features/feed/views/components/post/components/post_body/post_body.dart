// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/text_span_builder/hooks/use_text_span_builder.dart';
import 'package:ion/app/components/text_span_builder/text_span_builder.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_body/components/post_media/post_media.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_body/hooks/use_post_media.dart';
import 'package:ion/app/features/nostr/model/media_attachment.dart';
import 'package:ion/app/services/text_parser/text_match.dart';

class PostBody extends HookConsumerWidget {
  const PostBody({
    required this.postEntity,
    super.key,
  });

  final PostEntity postEntity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postMedia = usePostMedia(postEntity.data);

    final textSpanBuilder = useTextSpanBuilder(
      context,
      defaultStyle: context.theme.appTextThemes.body2.copyWith(
        color: context.theme.appColors.sharkText,
      ),
    );

    final filteredContent =
        (postMedia.isEmpty) ? postEntity.data.content : _excludeMediaLinks(postMedia);

    final postText = textSpanBuilder.build(
      filteredContent,
      onTap: (match) => TextSpanBuilder.defaultOnTap(context, match: match),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (postMedia.isNotEmpty) PostMedia(media: postMedia),
        Text.rich(
          postText,
        ),
      ],
    );
  }

  List<TextMatch> _excludeMediaLinks(List<MediaAttachment> postMedia) {
    return postEntity.data.content.where((match) {
      return !postMedia.any((media) => media.url == match.text);
    }).toList();
  }
}
