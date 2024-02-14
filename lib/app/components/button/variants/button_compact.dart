part of '../button.dart';

class _ButtonCompact extends Button {
  _ButtonCompact({
    super.key,
    required super.onPressed,
    super.trailingIcon,
    super.leadingIcon,
    super.label,
    super.mainAxisSize,
    super.type,
    super.disabled,
    super.tintColor,
    ButtonStyle style = const ButtonStyle(),
  }) : super(
          style: style.merge(
            OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0.s)),
              ),
              minimumSize: Size(44.0.s, 44.0.s),
            ),
          ),
        );
}
