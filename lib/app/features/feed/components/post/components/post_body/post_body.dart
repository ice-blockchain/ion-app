import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';

class PostBody extends StatelessWidget {
  const PostBody({
    super.key,
    required this.content,
  });

  final String content;

  @override
  Widget build(BuildContext context) {
    return ScreenSideOffset.small(
      child: Text(
        content,
        style: context.theme.appTextThemes.body2
            .copyWith(color: context.theme.appColors.sharkText),
      ),
    );
  }
}
