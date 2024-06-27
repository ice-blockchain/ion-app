import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class BottomActionBar extends StatelessWidget {
  const BottomActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0.s,
      padding: EdgeInsets.symmetric(horizontal: 16.0.s),
      decoration: BoxDecoration(
        color: context.theme.appColors.secondaryBackground,
      ),
      child: Row(
        children: [
          IconButton(
            icon: Assets.images.icons.iconGalleryOpen.icon(),
            onPressed: () {},
          ),
          SizedBox(width: 16.0.s),
          IconButton(
            icon: Assets.images.icons.iconCameraOpen.icon(),
            onPressed: () {},
          ),
          SizedBox(width: 16.0.s),
          IconButton(
            icon: Assets.images.icons.iconFeedAddfile.icon(),
            onPressed: () {},
          ),
          const Spacer(),
          Button.icon(
            borderRadius: BorderRadius.circular(100.0.s),
            onPressed: () {},
            icon: Assets.images.icons.iconFeedSendbutton.icon(),
          ),
        ],
      ),
    );
  }
}
