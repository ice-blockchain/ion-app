import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class ReplySentNotification extends StatelessWidget {
  const ReplySentNotification({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final textStyles = context.theme.appTextThemes;

    return SizedBox(
      height: 54.0.s,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0.s),
          color: colors.primaryAccent,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0.s),
          child: Row(
            children: [
              Assets.images.icons.iconBlockCheckboxOnWhite.icon(),
              SizedBox(width: 8.0.s),
              Text(
                context.i18n.post_reply_sent,
                style: textStyles.subtitle2.copyWith(color: colors.onPrimaryAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
