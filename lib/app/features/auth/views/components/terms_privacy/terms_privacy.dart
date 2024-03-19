import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/l10n/I10n.dart';

class TermsPrivacy extends StatelessWidget {
  const TermsPrivacy({super.key});

  @override
  Widget build(BuildContext context) {
    Widget handleMatch(String text, int index) {
      return GestureDetector(
        onTap: () {},
        child: Text(
          text,
          style: context.theme.appTextThemes.caption3.copyWith(
            color: context.theme.appColors.primaryAccent,
            fontSize: 8.0.s,
          ),
        ),
      );
    }

    final TextSpan replaced = replaceString(
      context.i18n.auth_privacy,
      tagRegex('link', isSingular: false),
      handleMatch,
    );

    return SizedBox(
      width: 220.0.s,
      child: Text.rich(
        replaced,
        textAlign: TextAlign.center,
        style: context.theme.appTextThemes.caption3.copyWith(
          color: context.theme.appColors.tertararyText,
        ),
      ),
    );
  }
}
