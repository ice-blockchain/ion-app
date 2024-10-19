import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class StoryPublishedNotification extends StatelessWidget {
  const StoryPublishedNotification({
    required this.height,
    super.key,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ColoredBox(
        color: context.theme.appColors.primaryAccent,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 3.0.s),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.svg.iconBlockCheckboxOn.icon(
                color: context.theme.appColors.onPrimaryAccent,
              ),
              SizedBox(width: 12.0.s),
              Text(
                context.i18n.story_has_been_posted,
                style: context.theme.appTextThemes.body2.copyWith(
                  color: context.theme.appColors.onPrimaryAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
