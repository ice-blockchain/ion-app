// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/post_data.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_body/components/post_media/post_media.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_body/hooks/use_post_media.dart';
import 'package:ion/app/services/text_parser/matchers/url_matcher.dart';

class PostBody extends ConsumerWidget {
  const PostBody({
    required this.postEntity,
    super.key,
  });

  final PostEntity postEntity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postMedia = usePostMedia(postEntity.data);

    //TODO::temp impl
    final postText = postEntity.data.content.fold<StringBuffer>(StringBuffer(), (result, match) {
      if (match.matcherType != UrlMatcher) {
        result.write(match.text);
      }
      return result;
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (postMedia.isNotEmpty) PostMedia(media: [...postMedia, ...postMedia]),
        Text(
          postText.toString(),
          style: context.theme.appTextThemes.body2.copyWith(
            color: context.theme.appColors.sharkText,
          ),
        ),
      ],
    );
  }
}
