import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

typedef ShadowBuilder = List<BoxShadow> Function(BuildContext context);

class PostRepliesActionBar extends StatelessWidget {
  const PostRepliesActionBar({
    this.padding,
    this.shadowBuilder,
    this.onSendPressed,
    super.key,
  });

  final VoidCallback? onSendPressed;

  factory PostRepliesActionBar.withShadow({EdgeInsets? padding}) => PostRepliesActionBar(
        padding: padding ?? EdgeInsets.symmetric(horizontal: 16.0.s),
        shadowBuilder: _defaultShadowBuilder,
      );

  final EdgeInsets? padding;
  final ShadowBuilder? shadowBuilder;

  static final ShadowBuilder _defaultShadowBuilder = (context) => [
        BoxShadow(
          color: context.theme.appColors.strokeElements.withOpacity(0.5),
          offset: Offset(0.0.s, -1.0.s),
          blurRadius: 5.0.s,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0.s,
      padding: padding,
      decoration: BoxDecoration(
        boxShadow: shadowBuilder?.call(context),
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
            onPressed: onSendPressed == null ? () {} : onSendPressed!,
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
