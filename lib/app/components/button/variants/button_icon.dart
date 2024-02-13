part of '../button.dart';

class _ButtonWithIcon extends Button {
  _ButtonWithIcon({
    super.key,
    super.type,
    required super.onPressed,
    required Widget icon,
    ButtonStyle style = const ButtonStyle(),
    double? size,
  }) : super(
          leadingIcon: icon,
          style: style.merge(
            OutlinedButton.styleFrom(
              fixedSize: Size.square(size ?? 56.0.s),
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
            ),
          ),
        );
}
