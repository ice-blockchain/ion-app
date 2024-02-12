import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/l10n/I10n.dart';

class TermsPrivacy extends StatelessWidget {
  const TermsPrivacy({super.key});

  @override
  Widget build(BuildContext context) {
    Widget handleMatch(String text, int index) {
      return InkWell(
        onTap: () {
          /// handle tap
        },
        child: Text(
          text,
          style: context.theme.appTextThemes.caption2.copyWith(
            color: context.theme.appColors.primaryAccent,
            decoration: TextDecoration.underline,
            height: 1.63,
          ),
        ),
      );
    }

    return SizedBox(
      width: 220,
      child: Text.rich(
        replaceString(
          context.i18n.auth_privacy,
          tagRegex('link', isSingular: false),
          handleMatch,
        ),
        textAlign: TextAlign.center,
        style: context.theme.appTextThemes.caption2.copyWith(height: 1.63),
      ),
    );
  }
}
