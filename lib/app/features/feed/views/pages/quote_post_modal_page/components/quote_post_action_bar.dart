import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class QuotePostActionBar extends StatelessWidget {
  const QuotePostActionBar({
    super.key,
    this.addPadding = true,
    this.showShadow = true,
  });

  final bool addPadding;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0.s,
      padding: addPadding ? EdgeInsets.symmetric(horizontal: 16.0.s) : null,
      decoration: BoxDecoration(
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: context.theme.appColors.strokeElements.withOpacity(0.5),
                  offset: Offset(0.0.s, -1.0.s),
                  blurRadius: 5.0.s,
                ),
              ]
            : null,
        color: context.theme.appColors.secondaryBackground,
      ),
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
            onPressed: () {},
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
