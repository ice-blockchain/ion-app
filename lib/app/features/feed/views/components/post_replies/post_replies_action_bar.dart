import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class PostRepliesActionBar extends StatelessWidget {
  const PostRepliesActionBar({
    this.padding,
    this.onSendPressed,
    super.key,
  });

  final VoidCallback? onSendPressed;

  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0.s,
      padding: padding,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {},
            child: Assets.svg.iconGalleryOpen.icon(),
          ),
          SizedBox(width: 12.0.s),
          GestureDetector(
            onTap: () {},
            child: Assets.svg.iconCameraOpen.icon(),
          ),
          SizedBox(width: 12.0.s),
          GestureDetector(
            onTap: () {},
            child: Assets.svg.iconFeedAddfile.icon(),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onSendPressed ?? () {},
            child: Container(
              width: 48.0.s,
              height: 28.0.s,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0.s),
                color: context.theme.appColors.primaryAccent,
              ),
              alignment: Alignment.center,
              child: Assets.svg.iconFeedSendbutton.icon(size: 16.0.s),
            ),
          ),
        ],
      ),
    );
  }
}
