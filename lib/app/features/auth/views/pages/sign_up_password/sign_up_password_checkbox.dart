import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:ice/l10n/i10n.dart';

class SignUpPasswordCheckbox extends HookWidget {
  const SignUpPasswordCheckbox({
    required this.onToggle,
    required this.selected,
    super.key,
  });

  final bool selected;

  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final checkboxTextSpan = useMemoized(
      () => replaceString(
        context.i18n.sign_up_password_acknowledge_checkbox,
        tagRegex('link', isSingular: false),
        (String text, int index) {
          return TextSpan(
            text: text,
            style: TextStyle(color: context.theme.appColors.primaryAccent),
            recognizer: TapGestureRecognizer()..onTap = () {},
          );
        },
      ),
    );

    return Row(
      children: [
        InkResponse(
          onTap: onToggle,
          splashFactory: InkRipple.splashFactory,
          child: selected
              ? Assets.images.icons.iconCheckboxOn.icon(size: 20.0.s)
              : Assets.images.icons.iconCheckboxOff.icon(size: 20.0.s),
        ),
        SizedBox(width: 8.0.s),
        Flexible(
          child: Text.rich(
            checkboxTextSpan,
            style: context.theme.appTextThemes.body2.copyWith(
              color: context.theme.appColors.primaryText,
            ),
          ),
        ),
      ],
    );
  }
}
