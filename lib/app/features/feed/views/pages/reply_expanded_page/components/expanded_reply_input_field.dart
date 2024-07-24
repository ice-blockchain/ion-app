import 'package:flutter/material.dart';
import 'package:ice/app/components/avatar/avatar.dart';
import 'package:ice/app/extensions/extensions.dart';

class ExpandedReplyInputField extends StatelessWidget {
  const ExpandedReplyInputField({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final textStyles = context.theme.appTextThemes;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Avatar(
          size: 30.0.s,
          imageUrl: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
        ),
        SizedBox(width: 10.0.s),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(top: 4.0.s),
            child: TextField(
              maxLines: null,
              minLines: 4,
              cursorColor: colors.primaryAccent,
              cursorHeight: 22.0.s,
              style: textStyles.body2,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: context.i18n.post_reply_hint,
                hintStyle: textStyles.caption.copyWith(color: colors.quaternaryText),
                contentPadding: const EdgeInsets.only(bottom: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
