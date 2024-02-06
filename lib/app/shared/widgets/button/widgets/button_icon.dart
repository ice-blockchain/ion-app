part of '../button.dart';

class _ButtonWithIcon extends Button {
  _ButtonWithIcon({
    super.key,
    super.type,
    required super.onPressed,
    required Widget icon,
    ButtonStyle style = const ButtonStyle(),
    double size = 56,
  }) : super(
          leadingIcon: icon,
          style: style.merge(
            OutlinedButton.styleFrom(
              fixedSize: Size.square(size),
              padding: EdgeInsets.zero,
            ),
          ),
        );
}
