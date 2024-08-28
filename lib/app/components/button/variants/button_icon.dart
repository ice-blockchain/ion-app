part of '../button.dart';

class _ButtonWithIcon extends Button {
  _ButtonWithIcon({
    super.onPressed,
    required Widget icon,
    super.key,
    super.type,
    super.tintColor,
    super.borderColor,
    super.borderRadius,
    super.backgroundColor,
    ButtonStyle style = const ButtonStyle(),
    double? size,
  }) : super(
          leadingIcon: icon,
          style: style.merge(
            OutlinedButton.styleFrom(
              fixedSize: Size.square(size ?? 56.0.s),
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              backgroundColor: backgroundColor,
            ),
          ),
        );
}
