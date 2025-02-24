import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class PasteSuffixButton extends StatelessWidget {
  const PasteSuffixButton({
    required this.onTap,
    super.key,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textStyles = context.theme.appTextThemes;
    final colors = context.theme.appColors;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.s),
        child: Text(
          context.i18n.common_paste,
          style: textStyles.caption.copyWith(color: colors.primaryAccent),
        ),
      ),
    );
  }
}
