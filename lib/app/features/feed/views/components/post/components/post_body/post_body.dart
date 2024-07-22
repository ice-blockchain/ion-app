import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/model/post/post_data.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_body/components/post_media/post_media.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_body/hooks/use_post_media.dart';
import 'package:ice/app/services/text_parser/matchers/url_matcher.dart';

class PostBody extends HookConsumerWidget {
  const PostBody({
    required this.postData,
    super.key,
  });

  final PostData postData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postMedia = usePostMedia(postData);

    //TODO::temp impl
    final postText = postData.content.fold<StringBuffer>(StringBuffer(), (result, match) {
      if (match.matcherType != UrlMatcher) {
        result.write(match.text);
      }
      return result;
    });
    return Column(
      children: [
        if (postMedia.isNotEmpty) PostMedia(media: postMedia),
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
