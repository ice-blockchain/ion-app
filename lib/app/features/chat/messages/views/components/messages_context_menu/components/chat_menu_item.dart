// SPDX-License-Identifier: ice License 1.0

part of '../messages_context_menu.dart';

class _ChatMenuItem extends StatelessWidget {
  const _ChatMenuItem({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.labelColor,
  });

  final String label;
  final Widget icon;
  final VoidCallback onPressed;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final textStyles = context.theme.appTextThemes;

    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.s, vertical: 8.0.s),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 99.0.s,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: textStyles.subtitle3.copyWith(
                    color: labelColor ?? colors.primaryText,
                  ),
                ),
              ),
              icon,
            ],
          ),
        ),
      ),
    );
  }
}
