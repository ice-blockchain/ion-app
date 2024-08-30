import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
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
            child: Assets.images.icons.iconGalleryOpen.icon(),
          ),
          SizedBox(width: 16.0.s),
          GestureDetector(
            onTap: () {},
            child: Assets.images.icons.iconCameraOpen.icon(),
          ),
          SizedBox(width: 16.0.s),
          GestureDetector(
            onTap: () {},
            child: Assets.images.icons.iconFeedAddfile.icon(),
          ),
          const Spacer(),
          Button(
            minimumSize: Size(48.0.s, 28.0.s),
            borderRadius: BorderRadius.circular(100.0.s),
            onPressed: onSendPressed ?? () {},
            leadingIcon: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0.s),
              child: Assets.images.icons.iconFeedSendbutton.icon(size: 20.0.s),
            ),
          ),
        ],
      ),
    );
  }
}
