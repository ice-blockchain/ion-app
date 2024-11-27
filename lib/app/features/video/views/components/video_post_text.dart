// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_body/components/post_media/post_media.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_body/hooks/use_post_media.dart';
import 'package:ion/app/services/text_parser/matchers/url_matcher.dart';
import 'package:ion/app/utils/post_text.dart';

class VideoTextPost extends HookConsumerWidget {
  const VideoTextPost({
    required this.postEntity,
    super.key,
  });

  final PostEntity postEntity;

  bool _isTextOneLine({
    required String text,
    required TextStyle style,
    required double maxWidth,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    return !textPainter.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postMedia = usePostMedia(postEntity.data);
    final isTextExpanded = useState(false);

    final postText = extractPostText(
      postEntity.data.content,
      excludeMatcherType: UrlMatcher,
    );

    final isOneLine = useMemoized(
      () {
        return _isTextOneLine(
          text: postText,
          style: context.theme.appTextThemes.body2.copyWith(color: Colors.white),
          maxWidth: MediaQuery.sizeOf(context).width,
        );
      },
      [
        postText,
        context.theme.appTextThemes.body2,
        MediaQuery.sizeOf(context).width,
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (postMedia.isNotEmpty) PostMedia(media: postMedia),
        GestureDetector(
          onTap: isOneLine ? null : () => isTextExpanded.value = !isTextExpanded.value,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  axisAlignment: -1,
                  child: child,
                ),
              );
            },
            child: isTextExpanded.value
                ? Text(
                    postText,
                    key: const ValueKey('expanded'),
                    style: context.theme.appTextThemes.body2.copyWith(
                      color: Colors.white,
                    ),
                  )
                : Text(
                    postText,
                    key: const ValueKey('collapsed'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.theme.appTextThemes.body2.copyWith(
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
