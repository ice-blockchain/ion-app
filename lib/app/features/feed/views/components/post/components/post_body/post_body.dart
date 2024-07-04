import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/feed/model/post_data.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_body/components/post_media_carousel.dart';

class PostBody extends StatelessWidget {
  const PostBody({
    required this.postData,
    super.key,
  });

  final PostData postData;

  @override
  Widget build(BuildContext context) {
    return ScreenSideOffset.small(
      child: Column(
        children: [
          if (postData.media.isNotEmpty)
            PostMediaCarousel(media: postData.media),
          Text(
            postData.body,
            style: context.theme.appTextThemes.body2.copyWith(
              color: context.theme.appColors.sharkText,
            ),
          ),
        ],
      ),
    );
  }
}
