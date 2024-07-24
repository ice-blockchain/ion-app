import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/utils/username.dart';

class ReplyingTo extends StatelessWidget {
  const ReplyingTo({
    required this.name,
    super.key,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final textStyles = context.theme.appTextThemes;

    return Text.rich(
      TextSpan(
        text: context.i18n.post_replying_to,
        style: textStyles.caption.copyWith(color: colors.sheetLine),
        children: [
          TextSpan(
            text: ' ${prefixUsername(username: name, context: context)}',
            style: textStyles.caption.copyWith(
              color: colors.primaryAccent,
            ),
          ),
        ],
      ),
    );
  }
}
